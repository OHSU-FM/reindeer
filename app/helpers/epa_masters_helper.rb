module EpaMastersHelper

  EPA_CODES_NEW = ['EPA1A', 'EPA1B', 'EPA2', 'EPA3', 'EPA4', 'EPA5', 'EPA6',
               'EPA7', 'EPA8', 'EPA9', 'EPA10', 'EPA11']

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

  NEW_EPA = {
       "epa1a" => ["pcp1", "pcp2", "pcp3", "mk1", "mk2", "ics1", "ics5", "pppd1", "pppd2"], #done
       "epa1b" => ["pcp1", "pcp2", "mk2", "ics1", "ics5", "pppd2"], #done
       "epa2" => ["pcp1", "pcp2",  "mk1", "mk2", "ics5", "pbli1", "pppd1", "pppd2"],  # done
       "epa3" => ["pcp2",  "mk1", "mk2", "mk3",  "pbli2", "ics2", "ics5", "pppd2"], #done
       "epa4" => ["pcp3", "mk1", "mk2", "mk3", "ics1", "ics3", "ics5", "pbli2", "sbp1", "pppd2"], #done
       "epa5" => ["pcp1", "pcp2", "pcp3", "mk1", "mk2", "mk3", "pbli2",  "ics2", "ics3", "ics4", "ics5", "pppd2"], # done
       "epa6" => ["pcp1", "pcp2", "pcp3", "mk1", "mk2", "mk3", "ics1", "ics2", "ics3", "pbli1", "pbli2", "pppd1", "pppd2"], #done
       "epa7" => ["pcp1", "pcp2", "pcp3", "mk1", "mk2", "mk3",  "pbli1", "pbli2", "ics2", "ics3", "ics5", "pppd1", "pppd2" ], #done
       "epa8" => ["pcp1", "pcp2", "pcp3", "mk2", "ics2", "ics3",  "ics4"],  #done
       "epa9" => ["pcp3", "mk2", "mk3", "sbp1", "ics1", "ics3", "ics5", "pppd1", "pppd2"], # done
       "epa10" => ["pcp1", "pcp2", "pcp3",  "mk2", "sbp1", "ics1", "ics2", "ics3", "ics4", "ics5", "pppd2"], #done
       "epa11" => ["pcp2", "pcp3", "mk1", "mk2", "mk3", "ics1", "ics5", "pbli2", "pppd1", "pppd2"] #done
     }

  class CohortMspe < ActiveRecord::Base
      table_name = ""
  end

  def get_colors
     return GRAPH_COLORS
  end

  def hf_epa_comp_codes(epa)
    epa_desc = epa + ": " + "<b>" + hf_get_epa_desc2(epa) + "</b>"
    return epa_desc + "<br>" + "Competency Code: " + "<b>" + EPA[epa.downcase].to_s.upcase.gsub('"', '') + "</b>"
  end

  def hf_epa_codes
    return EPA_CODES
  end

  def hf_epa_codes_new
    return EPA_CODES_NEW
  end

  def getEpaCodes(new_competency)
    if new_competency
      return EPA_CODES_NEW
    else
      return EPA_CODES
    end
  end


  #=== Creates new epa_master and epa_reviews with new EPA
  def hf_create_new_epas(selected_user_id, email, eg_cohorts)
    eg_full_name1, eg_full_name2 = hf_get_eg_members(eg_cohorts, email)

    EPA_CODES_NEW.each do |epa_code|
      epa_master = EpaMaster.where(user_id: selected_user_id, epa: "#{epa_code}").first_or_create do |epa|
        epa.user_id = selected_user_id
        epa.status = 'Not Yet'
        epa.epa = epa_code
      end
      epa_master.epa_reviews.where(epa: epa_master.epa).first_or_create do |review|
        review.epa = epa_master.epa
        review.review_date1 = DateTime.now
        review.review_date2 = DateTime.now
        review.badge_decision1 = "Not Yet"
        review.badge_decision2 = "Not Yet"
        review.trust1 = 'No Decision'
        review.trust2 = 'No Decision'
        review.reason1 ='Have not met the min/imum requirements'
        review.reason2 ='Have not met the minimum requirements'
        review.student_comments1 = 'You are making progress towards completing this EPA - continue to look for experiences.'
        review.student_comments2 = 'You are making progress towards completing this EPA - continue to look for experiences.'
        review.reviewer1 = eg_full_name1
        review.reviewer2 = eg_full_name2
      end
    end
  end

  def hf_ok_to_release_badge (status_date, release_date)

      if release_date.blank? and status_date.blank?
        return false
      elsif (!status_date.blank?) and (!release_date.blank?) and (status_date.strftime("%Y-%m-%d") <= release_date.strftime("%Y-%m-%d"))

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

  def hf_get_badge_info_new(user_id, new_competency)
    student_badge_hash = {}
    not_yet_status = {"status" => "Not Yet", "student_comments"=> "None" }
    student_badge_info = EpaMaster.where(user_id: user_id).select(:id, :user_id, :epa, :status, :status_date, :expiration_date).order(:epa)

    if student_badge_info.empty?
      EPA_CODES_NEW.each do |epa|
        student_badge_hash.store("#{epa}", not_yet_status)
      end
      return student_badge_hash
    end
    student_badge_info = student_badge_info.map(&:attributes)
    if new_competency  # new epa codes
      epa_codes = hf_epa_codes_new
    else
      epa_codes = hf_epa_codes
    end
    epa_codes.delete("EPA12")
    epa_codes.delete("EPA13")
    epa_codes.each do |epa|
      student_comments = []
      temp_badge = {}
      temp_badge = student_badge_info.select{|s| s if s["epa"] == epa.upcase}.first
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
        student_badge_hash.store("#{epa.upcase}", temp_badge )
      else
        student_comments << "None"
        temp_badge.store("student_comments", student_comments)
        student_badge_hash.store("#{epa.upcase}", temp_badge )
      end
    end

    return student_badge_hash
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

  def hf_epa_qa(comp_data, sid, full_name, new_competency)
    epa = {}
    epa["StudentId"] = sid
    epa["Student"] = full_name
    if new_competency
      lowercase_epa_codes_new = EPA_CODES_NEW.map(&:downcase) # comp_data key is in lowercase
      lowercase_epa_codes_new.delete("epa12")
      lowercase_epa_codes_new.delete("epa13")
      lowercase_epa_codes_new.each do |epa_code|
        temp_percent = 0
        NEW_EPA[epa_code].each do |c|
          temp_percent = temp_percent + comp_data[c]
        end
        epa[epa_code] = (temp_percent/NEW_EPA[epa_code].count.to_f).round(0)
      end
    else
      for i in 1..13
         epa_code = "epa" + i.to_s
          temp_percent = 0
          EPA[epa_code].each do |c|
            temp_percent = temp_percent + comp_data[c]
          end
          epa[epa_code] = (temp_percent/EPA[epa_code].count.to_f).round(0)
      end
    end

    return epa
  end

  def process_epa(students)

    data = []
    students.each do |student|
      if student.new_competency
        comp = student.new_competencies   #NewCompetency.where(user_id: student.id)
        comp = comp.map(&:attributes)
        comp_hash3 = hf_load_all_new_competencies(comp, 3)
        comp_data_clinical = hf_average_comp_new (comp_hash3)
        student_epa = hf_epa_qa(comp_data_clinical, student.sid, student.full_name, student.new_competency)
      else
        comp = Competency.where(student_uid: student.sid)
        comp = comp.map(&:attributes)
        comp_hash3 = hf_load_all_comp2(comp, 3)
        comp_data_clinical = hf_average_comp2 (comp_hash3)
        student_epa = hf_epa_qa(comp_data_clinical, student.sid, student.full_name, student.new_competency)
      end


      data.push student_epa
    end
    return data
  end

  def count_wbas(epa_codes, wbas, sid, full_name, matriculated_date, new_competency)
    epa_hash = {}
    tot_count = 0
    total_attending = 0
    epa_hash["StudentId"] = sid
    epa_hash["Student Name"] = full_name
    epa_hash["Matriculated Date"] = matriculated_date
    total_attending = wbas.select{|w| w.clinical_assessor if w.clinical_assessor.include? "Attending"}.compact.count

    #for i in 1..13
    epa_codes.each do |epa_code|
      #epa_code = 'EPA' + i.to_s
      epa_count = wbas.collect{|w| w.epa if w.epa == "#{epa_code}"}.compact.count
      tot_count += epa_count
      epa_hash[epa_code] = epa_count
    end
    epa_hash["TotalCount"] = tot_count
    epa_hash["Total Attending"] = total_attending
    return epa_hash
  end

  def reorder_epas(epas)
    epa_hash = {}
    for i in 1..13 do
        epa_hash.store("EPA#{i}", epas["EPA#{i}"])
    end
    return epa_hash
  end

  def total_count_on_wba(level_epa_wbas_count_hash)
    epa_tot = []
    for i in 1..13 do
      epa_tot[i] = 0
    end
    level_epa_wbas_count_hash.each do |levels, epas|
      epas.each do |key, val|
        if !val.nil?
          i = key.gsub("EPA", "").to_i
          epa_tot[i] += val
        end
      end
    end
    epa_tot_hash = {}
    for i in 1..13 do
      epa_tot_hash.store("EPA#{i}", epa_tot[i])
    end
    level_epa_wbas_count_hash.store("Total Count", epa_tot_hash)
    return level_epa_wbas_count_hash
  end

  def average_on_wba(level_epa_wbas_count_hash, cohort_count, permission_group_id, start_date, end_date)
    epa_average = Epa.joins(:user).where("users.permission_group_id=?", permission_group_id.to_s)
    .where("submit_date >= ? and submit_date <= ?",  start_date, end_date)
    .group(:epa).count(:epa)
    #epa_average = Epa.where("submit_date >= ? and submit_date <= ?", start_date, end_date).group(:epa).average(:involvement)
    epa_average = reorder_epas(epa_average)
    for i in 1..13 do
      epa_average["EPA#{i}"] = epa_average["EPA#{i}"].to_f / cohort_count
    end
    level_epa_wbas_count_hash.store("Class Mean", epa_average)
    return level_epa_wbas_count_hash
  end

  def hf_average_level_wbas(permission_group_id, start_date, end_date)
    students = User.where(permission_group_id: permission_group_id).select(:id, :sid, :email, :full_name).order(:full_name)

    average_level_epa_wbas_array = []

    students.each do |student|
      average_level_epa_wbas_hash = {}
      ave_epa_wbas = Epa.where("submit_date >= ? and submit_date <= ? and user_id=?", start_date, end_date, student.id).group(:epa).average(:involvement)
      average_level_epa_wbas_hash["StudentId"] = student.sid
      average_level_epa_wbas_hash["Student Name"] = student.full_name
      average_level_epa_wbas_hash.store("Ave Involvement", reorder_epas(ave_epa_wbas))
      average_level_epa_wbas_array.push average_level_epa_wbas_hash
    end

    return average_level_epa_wbas_array
  end

  def hf_count_level_wbas(permission_group_id, cohort, cohort_counts, start_date, end_date)
    level_epa_wbas_count_hash = {}
    #permission_group_id = PermissionGroup.find_by("title like ?", "%#{cohort}%").id

    for i in 1..4 do  #Level
      epas = Epa.joins("inner join users on users.id = epas.user_id" )
      .where("users.permission_group_id = ? and submit_date >= ? and submit_date <= ? and involvement = ?", permission_group_id, start_date, end_date, i)
      .group(:epa).count(:epa)
        #epas = Epa.where("user_id = ? and submit_date >= ? and submit_date <= ? and involvement =? ", student.id, start_date, end_date, i)
        level_epa_wbas_count_hash.store("Level #{i}", reorder_epas(epas))
    end
    level_epa_wbas_count_hash = total_count_on_wba(level_epa_wbas_count_hash)
    if cohort_counts[cohort].nil?
      cohort_counts[cohort] = PermissionGroup.find(permission_group_id).users.count
    end
    level_epa_wbas_count_hash = average_on_wba(level_epa_wbas_count_hash, cohort_counts[cohort], permission_group_id, start_date, end_date)

    return level_epa_wbas_count_hash
  end

  def process_wba(epa_codes, students, start_date, end_date)
    data = []
    students.each do |student|
        wbas = Epa.where("user_id=? and submit_date >= ? and submit_date <= ?", student.id, start_date, end_date)  # Epa table contains WBAs data
        student_epa = count_wbas(epa_codes, wbas, student.sid, student.full_name, student.matriculated_date, student.new_competency)

        # temp_hash = {}
        #
        # epa_hash = Epa.where("user_id=? and submit_date >= ? and submit_date <= ?", student.id, start_date, end_date).group(:epa).order(:epa).count
        # temp_hash["StudentId"] = student.sid
        # temp_hash["Student Name"] = student.full_name
        # temp_hash["Matriculated Date"] = student.matriculated_date
        # #re-arranging the EPAs on the graph by using Slice.
        # epa_hash = epa_hash.slice("EPA1A", "EPA1B", "EPA2", "EPA3", "EPA4", "EPA5", "EPA6", "EPA7", "EPA8", "EPA9", "EPA10", "EPA11", "EPA12", "EPA13")
        # # merge with a epa hash with zero count so that we can show it on graph.
        # epa_hash = epa_hash_merge(epa_hash)
        # epa_hash["TotalCount"] = epa_hash.values.sum
        #
        # temp_hash = temp_hash.merge(epa_hash)
        #
        # data.push temp_hash   #student_epa

        data.push student_epa

    end
    return data
  end

  def count_wba_clinical(wbas, sid, full_name, matriculated_date, uniq_assessors)
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

  def process_wba_clinical(students)
    data = []
    uniq_assessors = Epa.pluck(:clinical_assessor).uniq
    students.each do |student|
          wbas = Epa.where(user_id: student.id)
          if !student.sid.nil?
            wbas = count_wba_clinical(wbas, student.sid, student.full_name, student.matriculated_date, uniq_assessors)
            data.push wbas

          end
    end
    return data
  end

  def hf_process_cohort2 (permission_group_id, start_date, end_date, code)
    if permission_group_id.to_s >= "20" && permission_group_id.to_s <= "22" #Med26
      students = User.where(permission_group_id: permission_group_id, new_competency: true).select(:id, :sid, :email, :full_name, :matriculated_date, :new_competency).order(:full_name)
      epa_codes = getEpaCodes(new_competency = true)
      epa_codes.push "EPA12"
      epa_codes.push "EPA13"
    elsif permission_group_id.to_s >= "23"
      students = User.where(permission_group_id: permission_group_id, new_competency: true).select(:id, :sid, :email, :full_name, :matriculated_date, :new_competency).order(:full_name)
      epa_codes = getEpaCodes(new_competency = true)

    else
      students = User.where(permission_group_id: permission_group_id, new_competency: false).select(:id, :sid, :email, :full_name, :matriculated_date, :new_competency).order(:full_name)
      epa_codes = getEpaCodes(new_competency = false)

    end

    if code=='EPA'
      epas_data = process_epa(students)
    elsif code == 'ClinicalAssessor'
      wpa_clinical = process_wba_clinical(students)
    else
      wpa_data = process_wba(epa_codes, students, start_date, end_date)
    end
  end

  # def hf_process_cohort (cohort, start_date, end_date, code)
  #   CohortMspe.table_name = "#{cohort.downcase}_mspes"
  #   if CohortMspe.table_exists?
  #     students = CohortMspe.all
  #     students = students.sort_by(&:full_name)
  #   else
  #     # these cohorts do not have MSPE tables, they are never cohorts - not in clinical phase and not ready for EG Review
  #     permission_group = PermissionGroup.where("title like ?", "%#{cohort}%").first
  #     students = User.where(permission_group_id: permission_group.id).select(:id, :sid, :email, :full_name).order(:full_name)
  #
  #   end
  #   if code=='EPA'
  #     epas_data = hf_load_all_comp2(students)
  #   elsif code == 'ClinicalAssessor'
  #     wpa_clinical = process_wba_clinical(students)
  #   else
  #     wpa_data = process_wba(students, start_date, end_date)
  #   end
  # end

  def hf_process_student(student, code)
    if code == 'WBA'
      # process all students - for dashboard - using default dates
      return process_wba(student, "2016-01-01", "2030-12-31")
    elsif code == 'ClinicalAssessor'
      wba_clinical_assessor = process_wba_clinical(student)
      return wba_clinical_assessor
    else
      return []
    end
  end

  def reorder_epas (epa)
    new_order = {}
    EPA_CODES.each do |code|
      data = epa["#{code}"]
      new_order.store(code, data)
    end
    return new_order
  end

  def hf_wba_epa_graph(all_cohort_wba_epa_data)

    selected_categories = hf_epa_codes
    height = 600
    title =  "Number of WBAs by EPA" + '<br ><b>' + "(Level 4 Only)" + '</b>'
    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: title)
      #f.subtitle(text: '<br /><h4>Student: <b>' + student_name + '</h4></b>')
      f.xAxis(categories: selected_categories,
        labels: {
              style:  {
                          fontWeight: 'bold',
                          color: '#000000'
                      }
                }
      )
      all_cohort_wba_epa_data.keys.each do |key|   # skip the last two cohorts as they have not been badge
        if all_cohort_wba_epa_data["#{key}"].values.sum != 0 and !all_cohort_wba_epa_data["#{key}"].empty?
          f.series(name: key, yAxis: 0, data: reorder_epas(all_cohort_wba_epa_data["#{key}"]).values)
        end
      end
      pie_data = []
      all_cohort_wba_epa_data.keys.each do |key|   # skip the last two cohorts as they have not been badge
        if all_cohort_wba_epa_data["#{key}"].values.sum != 0
          series_data = {}
          series_data.store('name', key)
          series_data.store('y', all_cohort_wba_epa_data["#{key}"].values.sum )
          pie_data.push series_data
        end
      end

      f.series(type: 'pie',
              data: pie_data,
              center: [300,100], size: 150, showInLegend: false

      )

      #f.colors(["#FA6735", "#3F0E82", "#1DA877", "#EF4E49"])
      # f.colors(['#4572A7',
      #           '#AA4643',
      #           '#89A54E',
      #           '#80699B',
      #           '#3D96AE',
      #           '#DB843D',
      #           '#92A8CD',
      #           '#A47D7C',
      #           '#B5CA92'
      #           ])

      f.colors(['#2b908f', '#90ee7e', '#f45b5b', '#7798BF', '#aaeeee', '#ff0066', '#eeaaee', '#55BF3B', '#DF5353', '#7798BF', 'black', 'purple', 'blue'])

      f.yAxis [
         { tickInterval: 50,
           title: {text: "<b>No of WBAs Collected (Level 4)</b>", margin: 20}
         }
      ]
      f.plot_options(
        pie: {
            dataLabels: {
                enabled: true,
                crop: false,
                format: '<b>{point.name}</b>:<br>{point.percentage:.1f} %<br>value: {point.y}'
            }
        },

        column: {
            dataLabels: {
                enabled: true,
                crop: false,
                overflow: 'none'
            }
        },
        series: {
          cursor: 'pointer'
        }
      )
      f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0)
      #f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({
                defaultSeriesType: "column",
                scrollablePlotArea: {
                    minWidth: 1500,
                    scrollPositionX: 1
                },
                height: height,
                plotBorderWidth: 0,
                borderWidth: 1,
                plotShadow: false,
                borderColor: '',
                plotBackgroundImage: ''
              })
    end

    return chart

  end

  def hf_epa_badged_graph(all_cohort_epa_badged_data)
    selected_categories = all_cohort_epa_badged_data["Med21"].keys
    # epa_series = all_cohort_epa_badged_data["Med21"].values
    # epa_series2 = all_cohort_epa_badged_data["Med22"].values
    # epa_series3 = all_cohort_epa_badged_data["Med23"].values
    # categories = []
    # selected_categories.each do |category|
    #   categories.push '<a href="#" data-toggle="tooltip" title="Some tooltip text!">' + category + '</a>'
    # end

    height = 600

    title =  "Number of Badges by EPA" #+ '<br ><b>' + "(n = #{tot_count})" + '</b>'

    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: title)
      #f.subtitle(text: '<br /><h4>Student: <b>' + student_name + '</h4></b>')
      f.xAxis(categories: selected_categories,
        labels: {
              style:  {
                          fontWeight: 'bold',
                          color: '#000000'
                      }
                }
      )

      all_cohort_epa_badged_data.keys.each do |key|   # skip the last two cohorts as they have not been badge
        if all_cohort_epa_badged_data["#{key}"].values.sum != 0
          f.series(type: 'column', name: key, yAxis: 0, data: all_cohort_epa_badged_data["#{key}"].values)
        end
      end

      pie_data = []
      all_cohort_epa_badged_data.keys.each do |key|   # skip the last two cohorts as they have not been badge
        if all_cohort_epa_badged_data["#{key}"].values.sum != 0
          series_data = {}
          series_data.store('name', key)
          series_data.store('y', all_cohort_epa_badged_data["#{key}"].values.sum )
          pie_data.push series_data
        end
      end

      f.series(type: 'pie',
              data: pie_data,
              center: [300,100], size: 150, showInLegend: false

      )

      # ["#FA6735", "#3F0E82", "#1DA877", "#EF4E49"]
      # f.colors(['#4572A7',
      #           '#AA4643',
      #           '#89A54E',
      #           '#80699B',
      #           '#3D96AE',
      #           '#DB843D',
      #           '#92A8CD',
      #           '#A47D7C',
      #           '#B5CA92'
      #           ])

      f.yAxis [
         { tickInterval: 50,
           title: {text: "<b>No of Badges Awarded</b>", margin: 20}
         }
      ]
      f.plot_options(
        pie: {
            dataLabels: {
                enabled: true,
                crop: false,
                format: '<b>{point.name}</b>:<br>{point.percentage:.1f} %<br>value: {point.y}'
            }
        },
        column: {
            dataLabels: {
                enabled: true,
                crop: false,
                overflow: 'none'
            }
        },
        series: {
          cursor: 'pointer'
        }
      )
      f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0)
      #f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({
                defaultSeriesType: "column",
                width: 1600, height: height,
                plotBackgroundImage: ''
              })
    end

    return chart

  end

end
