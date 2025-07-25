module FixEgMembersHelper

  def hf_write_eg_assignment_data(eg_cohorts, permission_group_id)
    permission_group_title = PermissionGroup.find(permission_group_id).title.split(" ").last.gsub(/[()]/, "")
    file_name = "#{Rails.root}/tmp/#{permission_group_title}_eg_assignment.txt"

    CSV.open(file_name,'wb', col_sep: "\t") do |csvfile|
      csvfile << eg_cohorts.first.keys
      eg_cohorts.each do |data|
        csvfile << data.values
      end
    end
    return File.basename(file_name)
  end


  def hf_load_eg_cohorts2
    eg_cohorts = User.joins("inner join eg_cohorts on users.email = eg_cohorts.email").
    select(:full_name, :permission_group_id, :email, :eg_full_name1, :eg_email1, :eg_full_name2, :eg_email2, :user_id).map(&:attributes)
    return eg_cohorts
  end

  def hf_update_eg_cohorts(user, uniq_eg_hash, reviewer1, reviewer2)
    if !reviewer1.nil? or !reviwer2.nil?
      eg_email1 = uniq_eg_hash[reviewer1]
      eg_email2 = uniq_eg_hash[reviewer2]
      EgCohort.where(email: user.email).update(eg_email1: eg_email1, eg_email2: eg_email2, eg_full_name1: reviewer1, eg_full_name2: reviewer2)
    end
  end

  def hf_update_reviewers(epa_master, reviewer1, reviewer2)
    epa_master.each do |master|
      master.epa_reviews.each do |review|
        review.update(reviewer1: reviewer1, reviewer2: reviewer2)
      end
    end
  end

  def get_permission_group_id(in_cohort)
    permission_group = PermissionGroup.where("title like ?", "%#{in_cohort}%")
    return permission_group.first.id
  end

  def fix_eg_reviewers(user_id, in_reviewer1, in_reviewer2)
    epa_masters = EpaMaster.where(user_id: user_id).order(:id)
    epa_masters.each do |master|
      master.epa_reviews.each do |review|
        review.update(reviewer1: in_reviewer1, reviewer2: in_reviewer2)
      end
    end
  end

  def get_eg_names(row)
    eg_full_name1 = User.find_by(email: row["eg_email1"]).full_name
    eg_full_name2 = User.find_by(email: row["eg_email2"]).full_name
    row["eg_full_name1"] = eg_full_name1
    row["eg_full_name2"] = eg_full_name2
    return row

  end


  def loading_eg_cohort(row, log_file)
    uu = User.find_by(email: row["email"])
    if !uu.nil?
      row["user_id"] = uu.id
      row["permission_group_id"] = get_permission_group_id(row["cohort"])

      if row["permission_group_id"] == uu.permission_group_id
        row_hash = {}
        get_eg_names(row)
        full_name = row["full_name"]
        row_hash = row.to_hash
        row_hash.delete("cohort")
        row_hash.delete("full_name")

        student = EgCohort.find_by(user_id: uu.id)
        if student
          # if row["eg_full_name1"] != student.eg_full_name1 or row["eg_full_name2"] != student.eg_full_name2
            fix_eg_reviewers(uu.id, row["eg_full_name1"], row["eg_full_name2"])
          # end
          EgCohort.where(user_id: uu.id).first_or_create.update(row_hash.compact)
          log_file << " eg_cohorts: " + full_name + " --> " + row["email"] + " is created in eg_cohorts table."
        else
          EgCohort.where(email: row["email"]).first_or_create.update(row_hash.compact)
          log_file << " eg_cohorts: " + full_name.to_s + " --> " + row["email"].to_s + " is created in eg_cohorts table."
        end
      else
        log_file << " *** Need to check permission group on user (student): NOT updated! ==> #{uu.email} -- #{uu.full_name} --> row permission_group_id: #"
      end
     else
      log_file << row["full_name"] + "  " + row["email"] + " is not found in users table."
    end
  end

  def hf_process_eg_file(artifact_id)
    artifact = Artifact.find(artifact_id.to_i)
    log_file = []
    CSV.parse(ActiveStorage::Attachment.find(artifact.documents.first.id).download, headers: true, col_sep: "\t", encoding: 'cp1252') do |row|
      loading_eg_cohort(row, log_file)
    end
    return log_file
  end

end
