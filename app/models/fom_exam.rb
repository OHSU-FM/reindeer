class FomExam < ApplicationRecord
  belongs_to :user


  def self.format_date(in_date)
    temp_date = in_date.split("/")
    return temp_date[2] + "/" + temp_date[0] + "/" + temp_date[1]
  end

  def self.rename_file(in_file)
    #today_date = Date.today.strftime("%Y%m%d")
    filename =  in_file.split(".")
    in_file = filename.first + "_" + "processed"+ "." + filename.last

    return in_file
  end


  def self.update_exam(row, yes_updated)

       user = User.find_by(email: row["email"])
       if user.nil?
         yes_updated = false
       else
         row["user_id"] = user.id
         row["submit_date"] = format_date(row["submit_date"])
         row_hash = {}
         row_hash = row.to_hash
         row_hash.delete("email")
         FomExam.where(user_id: user.id, course_code: row["course_code"]).first_or_create.update(row_hash)
         yes_updated = true

       end

  end

  def self.process_file(attachment_id)
    log_results = []
    row_to_hash = {}
    no_updated = 0
    no_not_updated = 0
    total_count = 0
    CSV.parse(ActiveStorage::Attachment.find(attachment_id).download, headers: true) do |row|
      yes_updated = true
      total_count += 1
      FomExam.update_exam(row, yes_updated)
      row_to_hash = row.to_hash
      if yes_updated
        row_to_hash.store("status", " --> Updated")
        no_updated += 1
      else
        row_to_hash.store("status", " --> NOT Updated")
        no_not_updated += 1
      end
      log_results.push row_to_hash

    end
    attachment = ActiveStorage::Attachment.find(attachment_id)
    filename = attachment.blob.filename.to_s
    if !filename.include? 'processed'
      attachment.blob.update!(filename: rename_file(filename))
    end
    row_to_hash = {}
    row_to_hash.store("no_updated", no_updated)
    row_to_hash.store("no_not_updated", no_not_updated)
    row_to_hash.store("total_count", total_count)
    log_results.push row_to_hash

    return log_results
  end

  def self.exec_raw_sql attachment_id, permission_group
    row_to_hash = {}
    CSV.parse(ActiveStorage::Attachment.find(attachment_id).download, headers: true) do |row|
      row_to_hash = row.to_hash
    end
    sql = "select users.full_name, "
    sql_avg = "select "
    row_to_hash.each do |key, val|
      val = val.gsub(" ", "")
      sql += "#{key}, "
      if key.include? "comp1_wk"
        sql_avg += "AVG(#{key}) as avg_#{key}, "
      end
    end
    sql = sql.delete_suffix(", ") + " from fom_exams, users where users.permission_group_id = " + permission_group.to_s + " and users.id = fom_exams.user_id order by users.full_name ASC"
    sql_avg = sql_avg.delete_suffix(", ") + " from fom_exams, users where users.permission_group_id = " + permission_group.to_s + " and users.id = fom_exams.user_id "
    results = ActiveRecord::Base.connection.exec_query(sql)
    results_avg ||= ActiveRecord::Base.connection.exec_query(sql_avg)

    return results, results_avg,  row_to_hash

  end

end
