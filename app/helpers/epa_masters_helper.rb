module EpaMastersHelper

  EPA_CODES = ['EPA1', 'EPA2', 'EPA3', 'EPA4', 'EPA5', 'EPA6',
               'EPA7', 'EPA8', 'EPA9', 'EPA10', 'EPA11', 'EPA12', 'EPA13'
              ]

  def hf_epa_codes
    return EPA_CODES
  end

  def hf_get_eg_members(eg_cohorts, email)
    eg_full_name1 = eg_cohorts.collect{|e| e["eg_full_name1"] if e["email"] == email}.compact
    eg_full_name2 = eg_cohorts.collect{|e| e["eg_full_name2"] if e["email"] == email}.compact
    return eg_full_name1.join, eg_full_name2.join
  end

  def hf_load_eg_cohorts (eg_member_email)
    if File.file? (Rails.root + "public/epa_reviews/eg_cohorts.csv")
      eg_cohorts = []

      rows ||= CSV.foreach(Rails.root + "public/epa_reviews/eg_cohorts.csv", headers: true)
      rows.each do |row|
        eg_cohorts << row.to_hash
      end
      selected_cohorts = eg_cohorts.select{|eg| eg if eg["eg_email1"] == eg_member_email or eg["eg_email2"] == eg_member_email}
      if !selected_cohorts.blank?
        return selected_cohorts
      else
         return eg_cohorts
      end
    else
       return nil
    end
  end

  def hf_get_badge_info(user_id)

     student_badge_hash = {}
     not_yet_status = {"status" => "Not Yet"}
     student_badge_info = EpaMaster.where(user_id: user_id).select(:id, :user_id, :epa, :status, :status_date, :expiration_date).order(:epa)
     if student_badge_info.empty?
       EPA_CODES.each do |epa|
         student_badge_hash.store("#{epa}", not_yet_status)
       end
       return student_badge_hash
     end
     student_badge_info = student_badge_info.map(&:attributes)
     EPA_CODES.each do |epa|
       student_badge_hash.store("#{epa}", student_badge_info.select{|s| s if s["epa"] == epa}.first)
     end

     return student_badge_hash
  end

  def hf_format_date (in_date)
    if !in_date.nil?
      in_date = in_date.strftime("%m/%d/%Y")
    else
      return ""
    end
  end

  def hf_redact_text (review_rec)
    str_html1 = ''
    str_html2 = ''

    if !review_rec.reviewer1.blank? and review_rec.reviewer2.blank?
        # redact review1 data

        # #str_html = review_rec.badge_decision1 + " / " +
        #             review_rec.reviewer1 + " / " +
        #             review_rec.general_comments1  + " / "
        #str_html = '<span class="redact">' + str_html + '</span>'
        str_html1 = review_rec.reviewer1 + '<span class="glyphicon glyphicon-ok" style="color:green;"></span>'

    end
    if review_rec.reviewer1.blank? and !review_rec.reviewer2.blank?
          # redact review2 data

          # str_html = review_rec.badge_decision2 + " / " +
          #             review_rec.reviewer2 + " / " +
          #             review_rec.general_comments2  + " / "
          # str_html = '<span class="redact" style="color:black">' + str_html + '</span>'
          str_html2 = review_rec.reviewer2 + '<span class="glyphicon glyphicon-ok" style="color:green;"></span>'

    end

    if !review_rec.reviewer1.blank? and !review_rec.reviewer2.blank?
      if review_rec.badge_decision1 == "Badge"
          str_html1 = '<span class="text-success">' + review_rec.badge_decision1 + '</span>'
      else
          str_html1 = '<span class="bg-danger text-white">' + review_rec.badge_decision1 + '</span>'
      end
      str_html1 = str_html1 + ' / ' + review_rec.reviewer1 + ' / ' + review_rec.general_comments1.to_s
      if review_rec.badge_decision2 == "Badge"
          str_html2 = '<span class="text-success">' + review_rec.badge_decision2 + '</span>'
      else
          str_html2 = '<span class="bg-danger text-white">' + review_rec.badge_decision2 + '</span>'
      end
      str_html2 = str_html2 + ' / ' + review_rec.reviewer2 + ' / ' + review_rec.general_comments2.to_s
    end

    return str_html1, str_html2

  end

  def hf_load_eg_members
    if File.file? (Rails.root + "public/epa_reviews/eg_members.json")
      json_obj ||= File.read(Rails.root + "public/epa_reviews/eg_members.json")
      eg_members ||= JSON.parse(json_obj).map{|e| e["eg_member"]}

    else
       return nil
    end
  end

  def hf_get_epa_reviews(epa_master, selected_reviewer)
    epa_reviews = epa_master.epa_reviews.where("reviewer1 = ? or reviewer2 = ?", selected_reviewer, selected_reviewer)
  end

end
