class CsvSourceImport
  extend ActiveModel::Model
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file, :kind_of

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_csv_sources.map(&:valid?).all?
      imported_csv_sources.each(&:save!)
      true
    else
      imported_csv_sources.each_with_index do |source, index|
        source.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_csv_sources
    to_get = begin Object.const_get(kind_of.classify)
      kind_of.classify.constantize
    rescue NameError
      CsvSource
    end
    @imported_csv_sources ||= self.send("load_imported_#{kind_of.singularize}",
                                        to_get
                                       )
  end

  def load_imported_csv_source to_get
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      source = to_get.find_by_id(row["id"]) || to_get.new
      source.attributes = row.to_hash.slice(*to_get.attribute_names)
      source
    end
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path, csv_options: {encoding: "iso-8859-1:utf-8"})
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
