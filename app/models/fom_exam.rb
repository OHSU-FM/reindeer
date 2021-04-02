class FomExam < ApplicationRecord
  belongs_to :user
  belongs_to :user_only_fetch_email, -> {select("users.id, users.email, users.full_name")}, class_name: 'User', foreign_key: 'user_id'

  PREFIX_KEYS = ['comp1_wk', 'comp2a_hss', 'comp2b_bss', 'comp3_final', 'comp4_nbme', 'comp5a_hss', 'comp5b_bss', 'summary_comp']


  def self.comp_keys
    return PREFIX_KEYS
  end

  def self.to_csv
      CSV.generate do |csv|
        csv << column_names + ['user_id', 'email', 'full_name']
        all.each do |result|
          csv << result.attributes.values_at(*column_names) + result.user_only_fetch_email.attributes.values
        end
      end
    end

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
       #user = User.find_by(email: row["email"])
       formatted_sid = format('U%08d', row["sid"])
       user = User.find_by(sid: formatted_sid)
       if user.nil?
         #puts "email: " + row["email"]
         yes_updated = false
         #byebug
       else
         row["user_id"] = user.id
         row["submit_date"] = format_date(row["submit_date"])
         if row["comp1_dropped_quiz"] == 'nil'
           row["comp1_dropped_quiz"] = nil
           row["comp1_dropped_score"] = nil
         end
         row_hash = {}
         row_hash = row.to_hash
         row_hash.delete("email")
         row_hash.delete("full_name")
         row_hash.delete("sid")
         FomExam.where(user_id: user.id, course_code: row["course_code"], permission_group_id: row["permission_group_id"]).first_or_create.update(row_hash)
         yes_updated = true

       end

  end

  def self.process_file(attachment_id)

    log_results = []
    row_to_hash = {}
    no_updated = 0
    no_not_updated = 0
    total_count = 0

    CSV.parse(ActiveStorage::Attachment.find(attachment_id).download, headers: true, col_sep: "\t") do |row|
      yes_updated = true
      total_count += 1
      if !row["email"].blank?
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

  def self.execute_sql(*sql_array)
    connection.exec_query(send(:sanitize_sql_array, sql_array))
  end

  def self.exec_raw_sql user_id, attachment_id, permission_group_id, course_code
    row_to_hash = {}
    if attachment_id.to_i != -1
      CSV.parse(ActiveStorage::Attachment.find(attachment_id).download, headers: true, col_sep: "\t") do |row|
        row_to_hash = row.to_hash
        sql = "select users.full_name, "
        sql_avg = "select "
        row_to_hash.each do |key, val| # build sql using form label record --> customized headers
            val = val.gsub(" ", "")
            sql += "#{key}, "
            if key.match(Regexp.union(PREFIX_KEYS))
              sql_avg += "AVG(#{key}) as avg_#{key}, "
            end
        end
      end
    else # attachment_id = -1 get fom label from table fom_labels
      fom_label = FomLabel.where(permission_group_id: permission_group_id, course_code: course_code).first
      row_to_hash = JSON.parse(fom_label.labels).first  # fom_label.labels is a json object
      sql = "select users.full_name, "
      sql_avg = "select "
      row_to_hash.each do |fieldname, val|  # build sql using form label record --> customized headers
        if fieldname != 'permission_group_id'
          val = val.gsub(" ", "")
          sql += fieldname + ', '  #"#{key}, "
          if fieldname.match(Regexp.union(PREFIX_KEYS))
            sql_avg += 'AVG(' + fieldname + ') as avg_' + fieldname + ', '        # "AVG(#{key}) as avg_#{key}, "
          end
        end
      end
    end

    sql = sql.delete_suffix(", ")
    results = FomExam.execute_sql(sql + " from fom_exams, users where users.id = fom_exams.user_id and fom_exams.user_id = ? and fom_exams.course_code = ? and fom_exams.permission_group_id=?
                        order by users.full_name ASC",  user_id.to_i, course_code, permission_group_id.to_i).to_a


    # sql = sql.delete_suffix(", ") + " from fom_exams, users where users.id = fom_exams.user_id and " +
    #                                 " fom_exams.user_id = " + user_id + " and fom_exams.course_code = " + "'" + course_code + "' and "  +
    #                                 " fom_exams.permission_group_id=" + permission_group_id.to_s  + " order by users.full_name ASC"
    #
    # sql_avg = sql_avg.delete_suffix(", ") + " from fom_exams, users where fom_exams.permission_group_id= " + permission_group_id.to_s +
    #                                         " and users.id = fom_exams.user_id and fom_exams.course_code = " + "'" + course_code.to_s + "'"
    #
    # results = ActiveRecord::Base.connection.exec_query(sql).to_hash
    # results_avg ||= ActiveRecord::Base.connection.exec_query(sql_avg).to_hash

    sql_avg = sql_avg.delete_suffix(", ")
    results_avg ||= FomExam.execute_sql(sql_avg + " from fom_exams, users where fom_exams.permission_group_id = ?
                                                   and users.id = fom_exams.user_id and fom_exams.course_code = ?",
                                                   permission_group_id.to_i, course_code).to_a

    return results, results_avg,  row_to_hash

  end

  def self.get_attachment_by_filename(user_id)

      sql_filename = "select aa.id, att.record_id, att.blob_id, atb.filename from " +
                      "artifacts aa, " +
                      "active_storage_attachments att ," +
                      "active_storage_blobs atb " +
                      "where aa.user_id = " + "#{user_id}" +
      	              "aa.title = 'Other' and " +
      	              "aa.content = 'FoM CSV File' and " +
      	              "att.record_id = aa.id and " +
      	              "atb.id = att.blob_id and atb.filename like 'med23_fund_labels%'"

      results = ActiveRecord::Base.connection.exec_query(sql)
  end



end
