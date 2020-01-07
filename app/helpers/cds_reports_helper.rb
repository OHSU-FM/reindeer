module CdsReportsHelper

  ALLCOHORTS = ["Med23", "Med22", "Med21", "Med20", "Med19"]
  PROPER_LABELS = ["No & percent of students who <b>met/talked</b> with their coach within the past 2 months",
                  "No & percent of students who <b>met/talked</b> with their coach within the past 6 months",
                  "No & percent of students <b>without coach interactions</b> over the past year"]

  GOALS_PROPER_LABELS = ["No & percent of students with <b>active goals</b>",
                         "<b>Ave no of active goals</b> per student (only among those who have active goals)",
                         "No & Percent of students with <b>achieved goals</b>",
                         "<b>Ave no of achieved goals</b> per student (only among those who have achieved goals)"
                        ]


  def hf_all_cohorts
    return ALLCOHORTS
  end

   def hf_proper_label in_str
     PROPER_LABELS.each do |label|
        return label if label.include? in_str.downcase
      end
   end

   def hf_goals_proper_label in_str
     GOALS_PROPER_LABELS.each do |label|
       return label if label.include? in_str
     end
   end

   def hf_comp_percent(summ, cohort_array, cohort_title)
     return 0 if summ == 0

     percent = 0.0
     cohort_array.each do |cohort|
       cohort.each do |key, val|
         if !cohort_title.nil? and key.include? cohort_title
	   percent = ((summ.to_f / val) * 100).round(0)
         end
       end
     end
     return percent
   end

   def hf_get_cohorts_total(cohort_array, cohort_title)
     cohort_array.each do |cohort|
       cohort.each do |key, val|
         if key.include? cohort_title
           return val
         end
       end
     end
     return 0 ## not found in cohort_array
   end

  def hf_get_cohort_students(cohorts)
   cohorts_student = []
   students_hash = {}
    if cohorts.count > 100
     cohorts = PermissionGroup.where("title like ?", "%Students%").select{|g| g.title if !g.title.include? "Med18"}
     cohorts = cohorts.compact.sort.reverse
     tot_students = 0
     cohorts.each do |cohort|
       if !cohort.title.include?  'Med18'
         tot_students = cohort.users.count
         students_hash = {cohort.title => tot_students}
         cohorts_student.push students_hash
       end
      end

     return cohorts_student
    end
    tot_students = 0
    cohorts.each do |cohort|
      if !cohort.title.include?  'Med18'
        temp_cohort = cohort.title.split(" - ").last
        tot_students = cohort.users.count
        students_hash = {temp_cohort => tot_students}
        cohorts_student.push students_hash
      end
    end
    return cohorts_student
  end

  def hf_get_past_due(start_date, end_date, option, cohorts)
    process_cohort = ["Med23", "Med22", "Med21", "Med20"]
    past_due_hash = {}

    process_cohort.each do |proc_cohort|
      past_due_students = []
      cohorts.each do |cohort|
        if cohort.title.include? proc_cohort
          cohort.users.each do |user|
            if option == 'Meetings'
              if user.meetings.where("created_at >= ? and created_at <= ?", start_date, end_date).count == 0
                past_due_students << user.full_name + "|" + cohort.title
              end
            elsif option == 'Goals'
              if user.goals.where("created_at >= ? and created_at <= ?", start_date, end_date).count == 0
                past_due_students << user.full_name + "|" + cohort.title
              end
            end
          end
        end
      end
      past_due_hash[proc_cohort] = past_due_students.sort
    end

    return past_due_hash
  end

  def hf_get_past_data(cohorts)
    past_data = Hash.new{ |h,k| h[k] = Hash.new 0 }
    ALLCOHORTS.each do |cohort|
        ["Past 2 Months", "Past 6 Months", "Past Year"].each do |item|
            past_data[cohort][item] = 0
        end
    end
    cohorts.each do |cohort|
      if !cohort.title.include?  'Med18'
        cohort.users.each do |user|
          #if user.meetingAchieved Goalss.empty?
            temp_cohort = cohort.title.split(" - ").last
            if user.meetings.where(created_at: 2.months.ago..Time.now).count > 0
              past_data[temp_cohort]["Past 2 Months"] += 1
            end
            if user.meetings.where(created_at: 6.months.ago..Time.now).count > 0
              past_data[temp_cohort]["Past 6 Months"] += 1
            end
            if user.meetings.where(created_at: 1.year.ago..Time.now).count == 0
              past_data[temp_cohort]["Past Year"]     += 1
            end
          #end
       end
      end
    end
    return past_data
  end

  def hf_cds_reporting(cohorts)
    uniq_subjects ||= Coaching::Meeting.distinct.pluck(:subject)
    big_hash = Hash.new{ |h,k| h[k] = Hash.new 0 }
    coach_array = Hash.new 0
    ALLCOHORTS.each do |cohort|
        uniq_subjects.sort.each do |subject|
          if !subject.empty?
            big_hash[cohort][subject.first] = 0
          end
        end
    end
    cohorts.each do |cohort|
        cohort.users.each do |user|
            if !cohort.title.include?  'Med18'
              if !user.meetings.empty?
                #puts "cohort: " + cohort.title + " -->
                #puts "subjects: " +  user.meetings.first.subject.map(&:inspect).join(',')
                subject = user.meetings.first.subject.map(&:inspect).join(',')
                if subject.to_s != ""
                  #subject_hash[subject] += 1
                  #puts "cohort.title --> " + cohort.title
                  temp_cohort = cohort.title.split(" - ").last
                  meetings_count = user.meetings.count
                  big_hash[temp_cohort][subject] += meetings_count

                  if @coach_all == "ALL"
                    temp_coach = cohort.title.split(" - ").first # greb the coach name
                    coach_array[temp_coach] += meetings_count
                  else
                    temp_coach = cohort.title.split(" - ").last # greb the cohort instead
                    coach_array[temp_coach] += meetings_count
                  end

                end
              end

            end

        end
    end
    big_hash = big_hash.sort_by{|k, v| k}.reverse
    coach_array = coach_array.sort_by{|k, v| v}.reverse

    return big_hash, coach_array
  end

  def hf_get_coaches_not_met_past_2_months (cohorts)
    coaches_have_not_met_2 = Hash.new{ |h,k| h[k] = Hash.new Array.new}

    ALLCOHORTS.each do |cohort|
        ["Have Not Met Past 2 Months", "Have Not Met Past 6 Months", "Have Not Met Past Year"].each do |subject|
            coaches_have_not_met_2[cohort][subject] = []
        end
    end

    cohorts.each do |cohort|
      cohort.users.each do |user|
        if !cohort.title.include?  'Med18'
          temp_cohort = cohort.title.split(" - ").last
          if user.meetings.where(created_at: 2.months.ago..Time.now).count == 0
            coaches_have_not_met_2[temp_cohort]["Have Not Met Past 2 Months"].push cohort.title + "/" + user.full_name
          end
          if user.meetings.where(created_at: 6.months.ago..Time.now).count == 0
            coaches_have_not_met_2[temp_cohort]["Have Not Met Past 6 Months"].push cohort.title + "/" + user.full_name
          end
          if user.meetings.where(created_at: 1.year.ago..Time.now).count == 0
            coaches_have_not_met_2[temp_cohort]["Have Not Met Past Year"].push cohort.title + "/" + user.full_name
          end
        end
      end
    end
    return coaches_have_not_met_2
  end

  def hf_total_active_goals(cohorts)
    goals_data = Hash.new{ |h,k| h[k] = Hash.new 0 }
    ALLCOHORTS.each do |cohort|
        ["active goals", "Ave no of active goals", "achieved goals", "Ave no of achieved goals"].each do |item|
            goals_data[cohort][item] = 0
        end
    end
    total_students_active = 0
    total_students_achieved = 0
    cohorts.each do |cohort|
      if !cohort.title.include?  'Med18'
        cohort.users.each do |user|
          #if user.meetings.empty?
            temp_cohort = cohort.title.split(" - ").last
            goal_count = user.goals.count

            if goal_count > 0

              goals_data[temp_cohort]["active goals"] += 1
              #temp storage to store the total_students_active goals
              goals_data[temp_cohort]["Ave no of active goals"] += goal_count
            end
            achieved_goal_count = user.goals.where(g_status: 'Completed').count

            if achieved_goal_count > 0

              goals_data[temp_cohort]["achieved goals"] += 1
              #temp storage to store the total students with achieved goals
              goals_data[temp_cohort]["Ave no of achieved goals"] += achieved_goal_count
            end
          #end
        end
       end
     end

    ALLCOHORTS.each do |cohort|
      total_students_active = goals_data[cohort]["active goals"]
      total_students_achieved = goals_data[cohort]["achieved goals"]
      goals_data[cohort]["Ave no of active goals"] = total_students_active == 0 ? 0 : goals_data[cohort]["Ave no of active goals"]/total_students_active.to_f
      goals_data[cohort]["Ave no of achieved goals"] = total_students_achieved == 0 ? 0 : goals_data[cohort]["Ave no of achieved goals"]/total_students_achieved.to_f
    end
    return goals_data
  end

  def hf_parse_student(coach_array)
    return [] if coach_array.empty?
    student_array = []
    coach_array.each do |student|
      str = student.split("/").last  # get student
      student_array.push str
    end
    student_array = student_array.sort
    return student_array

  end

  def hf_parse_coach(coach_array)
    return [] if coach_array.empty?
    temp_array = []
    coach_array.each do |coach|
      str = coach.split("/").first  # get student
      temp_array.push str
    end
    temp_array = temp_array.uniq.sort
    return temp_array

  end
end
