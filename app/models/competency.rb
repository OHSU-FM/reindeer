class Competency < ApplicationRecord
  belongs_to :user

  def self.write_hash_to_json_file(hash, filename)
     File.open(filename,"w") do |f|
       f.write(JSON.pretty_generate(hash))
     end
  end

  def self.load_class_mean(permission_group_id)
    today_date = Date.today.to_s
    file_name = "#{Rails.root}/tmp/class_mean_#{permission_group_id}_#{today_date}.json"
    if File::exists?(file_name)
      file = File.read(file_name)
      return JSON.parse(file)
    else
      return nil
    end

  end

  def self.create_class_mean(class_mean, permission_group_id)
      today_date = Date.today.to_s
      write_hash_to_json_file(class_mean, "#{Rails.root}/tmp/class_mean_#{permission_group_id}_#{today_date}.json" )
  end
end
