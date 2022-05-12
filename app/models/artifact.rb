class Artifact < ApplicationRecord
  belongs_to :user
  has_many_attached :documents
  # Note that implicit association has a plural form in this case
  scope :with_eager_loaded_images, -> { eager_load(images_attachments: :blob) }

  validates :documents, presence: true, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg', 'application/pdf', 'application/csv', 'application/x-csv',  'text/plain', 'text/csv'], size_range: 1..10.megabytes }


  def self.format_date(in_date)
    temp_date = in_date.split("/")
    return temp_date[2] + "/" + temp_date[0] + "/" + temp_date[1]
  end

  def self.update_preceptor_eval(row)
     user = User.find_by(email: row["email"])
     if user.nil?
       return false
     else
       row["user_id"] = user.id
       row["submit_date"] = format_date(row["submit_date"])
       #puts row.to_hash
       row_hash = {}
       row_hash = row.to_hash
       row_hash.delete("email")
       row_hash.delete("full_name")
       PreceptorAssess.where(response_id: row["response_id"]).first_or_create.update(row_hash)
     end

     return true
  end

  def self.process_preceptor_data (artifact)
    log_results = []
    row_to_hash = {}
    no_updated = 0
    no_not_updated = 0
    total_count = 0

    CSV.parse(ActiveStorage::Attachment.find(artifact.documents.first.id).download, headers: true, col_sep: "\t", encoding: 'cp1252') do |row|

      yes_updated = true
      total_count += 1
      if !row["email"].blank?
        yes_updated = false
        yes_updated = update_preceptor_eval(row)

        if yes_updated
          no_updated += 1
        else
          row_to_hash.store(row["full_name"], " --> NOT Updated")
          no_not_updated += 1
          log_results.push row_to_hash
        end

      end
    end
    # attachment = ActiveStorage::Attachment.find(artifact.documents.first.id)
    # filename = attachment.blob.filename.to_s
    # if !filename.include? 'processed'
    #   attachment.blob.update!(filename: rename_file(filename))
    # end
    row_to_hash = {}
    row_to_hash.store("no_updated", no_updated)
    row_to_hash.store("no_not_updated", no_not_updated)
    row_to_hash.store("total_count", total_count)
    log_results.push row_to_hash

    return log_results

  end

end
