module EpaMastersHelper

  EPA_CODES = ['EPA1', 'EPA2', 'EPA3', 'EPA4', 'EPA5', 'EPA6',
               'EPA7', 'EPA8', 'EPA9', 'EPA10', 'EPA11', 'EPA12', 'EPA13'
              ]

  EPA = { "epa1" => ["pcp1", "ics1", "ics2", "ics3", "ics4", "pppd1", "pppd2", "pppd3", "pppd7", "pppd10", "sbpic3" ],
          "epa2" => ["pcp1", "pcp2", "pcp3", "mk1", "mk2", "mk3", "pbli1", "ics6", "pppd7", "pppd10", "pppd11", "sbpic3"],
          "epa3" => ["pcp2", "pcp3", "pcp4", "pcp5", "mk2", "mk3", "mk4", "mk5", "pbli3", "pbli4", "ics2", "pppd3", "pppd7", "pppd10", "sbpic2", "sbpic3" ],
          "epa4" => ["pcp3", "pcp4", "mk1", "mk2", "mk3", "pbli1", "pbli3", "pbli4", "ics1", "ics2", "pppd7", "pppd10", "sbpic2", "sbpic3"],
          "epa5" => ["pcp4", "mk5", "ics1", "ics2", "ics5", "ics6", "ics8", "pppd2", "pppd5", "pppd7", "pppd9", "pppd10", "sbpic1", "sbpic3", "sbpic4", "sbpic5"],
          "epa6" => ["pcp4", "pbli1", "pbli2", "ics1", "ics2", "ics6", "ics7", "ics8", "pppd2", "pppd4", "pppd7", "pppd10", "pppd11", "sbpic3", "sbpic4", "sbpic5"],
          "epa7" => ["mk1", "mk2", "mk3", "mk4", "mk5", "pbli1", "pbli2", "pbli3", "pbli4", "pbli5", "pppd7", "pppd10", "sbpic3" ],
          "epa8" => ["ics4", "ics5", "ics6", "ics7", "ics8", "pppd2", "pppd7", "pppd10", "sbpic3", "sbpic4", "sbpic5"],
          "epa9" => ["mk5", "ics3", "ics6", "pppd4", "pppd7", "pppd8", "pppd9", "pppd10", "sbpic3", "sbpic4", "sbpic5"],
          "epa10" => ["pcp1", "pcp2", "pcp3", "pcp4", "pcp6", "mk2", "ics3", "ics6", "ics8", "pppd3", "pppd4", "pppd6", "pppd7", "pppd10", "sbpic3", "sbpic5"],
          "epa11" => ["pcp4", "mk1", "mk2", "mk3", "ics1", "ics2", "ics3", "ics5", "pppd7", "pppd9", "pppd10", "sbpic2", "sbpic3"],
          "epa12" => ["pcp6", "ics1", "ics5", "pppd3", "pppd4", "pppd6", "pppd7", "pppd9", "pppd10", "sbpic3"],
          "epa13" => ["mk5", "pbli2", "pbli5", "pbli6", "pbli8", "ics1", "ics6", "pppd7", "pppd10", "sbpic1", "sbpic3", "sbpic5"]
  }

  class CohortMspe < ActiveRecord::Base
      table_name = ""
  end

  def hf_epa_codes
    return EPA_CODES
  end

  def hf_ok_to_release_badge (status_date, release_date)

      if release_date.blank? and status_date.blank?
        return false
      elsif (!status_date.blank?) and (!release_date.blank?) and (status_date <= release_date)

        return true
      elsif (status_date.blank?) and (!release_date.blank?)
        return true
      else
        return false
      end
  end

  def hf_get_eg_members(eg_cohorts, email)
    eg_full_name1 = eg_cohorts.collect{|e| e["eg_full_name1"] if e["email"] == email}.compact
    eg_full_name2 = eg_cohorts.collect{|e| e["eg_full_name2"] if e["email"] == email}.compact
    return eg_full_name1.join, eg_full_name2.join
  end

  def hf_load_eg_cohorts
    if File.file? (Rails.root + "public/epa_reviews/eg_cohorts.csv")
      eg_cohorts = []
      rows ||= CSV.foreach(Rails.root + "public/epa_reviews/eg_cohorts.csv", headers: true)
      rows.each do |row|
        eg_cohorts << row.to_hash
      end
      if !eg_cohorts.blank?
         return eg_cohorts
      else
       return nil
      end
    end
  end

  def hf_get_badge_info(user_id)

     student_badge_hash = {}
     not_yet_status = {"status" => "Not Yet", "student_comments"=> "None" }
     student_badge_info = EpaMaster.where(user_id: user_id).select(:id, :user_id, :epa, :status, :status_date, :expiration_date).order(:epa)

     if student_badge_info.empty?
       EPA_CODES.each do |epa|
         student_badge_hash.store("#{epa}", not_yet_status)

       end

       return student_badge_hash
     end
     student_badge_info = student_badge_info.map(&:attributes)

     EPA_CODES.each do |epa|
       student_comments = []
       temp_badge = {}
       temp_badge = student_badge_info.select{|s| s if s["epa"] == epa}.first
       if temp_badge["status"].to_s == ""
          temp_badge["status"] = 'Not Yet'
       end

       epa_reviews_final = EpaReview.where(reviewable_id: temp_badge["id"], epa: temp_badge["epa"]).last
       if !epa_reviews_final.blank?
         if epa_reviews_final["student_comments1"].to_s != ""
            student_comments << epa_reviews_final["student_comments1"]
         else
            student_comments << "None"
         end

         if !epa_reviews_final["student_comments2"].to_s != ""
            student_comments << epa_reviews_final["student_comments2"]
         else
            student_comments << "None"
         end
         student_comments = student_comments.uniq.reject(&:blank?)
         temp_badge.store("student_comments", student_comments)
         student_badge_hash.store("#{epa}", temp_badge )
       else
         student_comments << "None"
         temp_badge.store("student_comments", student_comments)
         student_badge_hash.store("#{epa}", temp_badge )
       end
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

  def hf_redact_text (review_rec, current_user)
    str_html1 = ''
    str_html2 = ''

    # if !review_rec.reviewer1.blank? and review_rec.reviewer2.blank?
    #     # redact review1 data
    #
    #     # #str_html = review_rec.badge_decision1 + " / " +
    #     #             review_rec.reviewer1 + " / " +
    #     #             review_rec.general_comments1  + " / "
    #     #str_html = '<span class="redact">' + str_html + '</span>'
    #     str_html1 = review_rec.reviewer1 + '<span class="glyphicon glyphicon-ok" style="color:green;"></span>'
    #
    # end
    # if review_rec.reviewer1.blank? and !review_rec.reviewer2.blank?
    #       # redact review2 data
    #
    #       # str_html = review_rec.badge_decision2 + " / " +
    #       #             review_rec.reviewer2 + " / " +
    #       #             review_rec.general_comments2  + " / "
    #       # str_html = '<span class="redact" style="color:black">' + str_html + '</span>'
    #       str_html2 = review_rec.reviewer2 + '<span class="glyphicon glyphicon-ok" style="color:green;"></span>'
    #
    # end

    if !review_rec.reviewer1.blank? or !review_rec.reviewer2.blank?
      date1 = review_rec.review_date1.nil? ? review_rec.review_date1.to_s : review_rec.review_date1.strftime("%m-%d-%Y")
      date2 = review_rec.review_date2.nil? ? review_rec.review_date2.to_s : review_rec.review_date2.strftime("%m-%d-%Y")
      if review_rec.badge_decision1 == "Badge" and review_rec.badge_decision2 == "Badge"

        str_html1 = '<span class="text-success">' + review_rec.badge_decision1 + '</span>'
        str_html1 = date1 + " / " + str_html1 + ' / ' + review_rec.reviewer1 # + ' / ' + review_rec.general_comments1.to_s
        str_html2 = '<span class="text-success">' + review_rec.badge_decision2 + '</span>'
        str_html2 = date2 + " / " + str_html2 + ' / ' + review_rec.reviewer2  #+ ' / ' + review_rec.general_comments2.to_s
        return str_html1, str_html2
      end

      if review_rec.reviewer1 == current_user.full_name
        if review_rec.badge_decision1 == "Badge"
            str_html1 = '<span class="text-success">' + review_rec.badge_decision1 + '</span>'
        else
            str_html1 = '<span class="bg-danger text-white">' + review_rec.badge_decision1 + '</span>'
        end
        str_html1 = date1 + " / " + str_html1 + ' / ' + review_rec.reviewer1   #+ ' / ' + review_rec.general_comments1.to_s
        str_html2 = ''
      elsif review_rec.reviewer2 == current_user.full_name
          if review_rec.badge_decision2 == "Badge"
              str_html2 = '<span class="text-success">' + review_rec.badge_decision2 + '</span>'
          else
              str_html2 = '<span class="bg-danger text-white">' + review_rec.badge_decision2 + '</span>'
          end
          str_html2 = date2 + " / " + str_html2 + ' / ' + review_rec.reviewer2   #+ ' / ' + review_rec.general_comments2.to_s
          str_html1 = ''
      end

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

  def hf_epa_qa(comp_data, sid, full_name)
    epa = {}
    epa["StudentId"] = sid
    epa["Student"] = full_name
    for i in 1..13
       epa_code = "epa" + i.to_s
        temp_percent = 0
        EPA[epa_code].each do |c|
          temp_percent = temp_percent + comp_data[c]
        end
        epa[epa_code] = (temp_percent/EPA[epa_code].count.to_f).round(0)
    end

    return epa
  end

  def process_epa(students)

    data = []
    students.each do |student|
      comp = Competency.where(student_uid: student.sid)
      comp = comp.map(&:attributes)
      comp_hash3 = hf_load_all_comp2(comp, 3)
      comp_data_clinical = hf_average_comp2 (comp_hash3)
      student_epa = hf_epa_qa(comp_data_clinical, student.sid, student.full_name)

      data.push student_epa
    end
    return data
  end

  def count_wbas(wbas, sid, full_name)
    epa_hash = {}
    tot_count = 0
    epa_hash["StudentId"] = sid
    epa_hash["Student Name"] = full_name
    for i in 1..13
      epa_code = 'EPA' + i.to_s
      epa_count = wbas.collect{|w| w.epa if w.epa == "#{epa_code}"}.compact.count
      tot_count += epa_count
      epa_hash.store(epa_code, epa_count)
    end
    epa_hash["TotalCount"] = tot_count
    return epa_hash

  end

  def process_wba(students)
    data = []
    students.each do |student|
      user = User.find_by(sid: student.sid)
      if !user.nil?
        wbas = Epa.where(user_id: user.id)
        student_epa = count_wbas(wbas, student.sid, student.full_name)
        data.push student_epa
      end
    end
    return data
  end

  def count_wba_clinical(wbas, sid, full_name,matriculated_date, uniq_assessors)
    wba_hash = {}
    wba_hash["StudentId"] = sid
    wba_hash["Student Name"] = full_name
    wba_hash["Matriculated Date"] = matriculated_date
    tot_count = 0
    uniq_assessors.each do |assessor|
      wba_count = 0
      wba_count = wbas.collect{|w| w.clinical_assessor if w.clinical_assessor.include? assessor}.compact.count
      tot_count += wba_count
      wba_hash.store(assessor, wba_count)
    end
    wba_hash["TotalCount"] = tot_count
    return wba_hash
  end

  def process_wba_clinical(students, uniq_assessors)
    data = []
    students.each do |student|
      user = User.find_by(sid: student.sid)
      if !user.nil?
        wbas = Epa.where(user: user.id).select(:id, :user_id, :clinical_assessor)
        student_wba = count_wba_clinical(wbas, student.sid, student.full_name, user.matriculated_date, uniq_assessors)
        data.push student_wba
      end
    end
    return data
  end

  def hf_process_cohort (cohort, code)
    CohortMspe.table_name = "#{cohort.downcase}_mspes"
    if CohortMspe.table_exists?
      students = CohortMspe.all
      students = students.sort_by(&:full_name)
    else
      permission_group = PermissionGroup.where("title like ?", "%#{cohort}%").first
      students = User.where(permission_group_id: permission_group.id).select(:id, :sid, :email, :full_name).order(:full_name)

    end
    if code=='EPA'
      epas_data = process_epa(students)
    elsif code == 'ClinicalAssessor'
      uniq_assessors = Epa.distinct.pluck(:clinical_assessor).sort
      wpa_clinical = process_wba_clinical(students, uniq_assessors)
    else
      wpa_data = process_wba(students)
    end

  end


end
