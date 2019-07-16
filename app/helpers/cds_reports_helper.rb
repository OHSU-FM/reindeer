module CdsReportsHelper

  ALLCOHORTS = ["Med23", "Med22", "Med21", "Med20", "Med19"]
  PROPER_LABELS = ["No & % of students who <b>met/talked</b> with their coach within the past 2 months",
                  "No & % of students who <b>met/talked</b> with their coach within the past 6 months",
                  "No & % of students <b>without coach interactions</b> over the past year"]

  def hf_all_cohorts
    return ALLCOHORTS
  end

   def hf_proper_label in_str
     PROPER_LABELS.each do |label|
        return label if label.include? in_str.downcase
      end
   end

   def hf_comp_percent(summ, cohort_array, cohort_title)
     return 0 if cohort_title.nil?
     cohort_array.each do |cohort|
       cohort.each do |key, val|
         if key.include? cohort_title
           if val == 0
             return 0
           else
             percent = ((summ.to_f / val.to_f) * 100).round(0)
             return percent
           end
         end
       end
     end
   end

   def hf_get_cohorts_total(cohort_array, cohort_title)
     cohort_array.each do |cohort|
       cohort.each do |key, val|
         if key.include? cohort_title
           return val
         end
       end
     end
   end

   def hf_get_cohort_students
     cohorts_student = []
     tot_students = {}
      cohorts = PermissionGroup.where("title like ?", "%Students%").select{|g| g.title if !g.title.include? "Med18"}
      cohorts = cohorts.compact.sort.reverse
      cohorts.each do |cohort|
        tot_students = cohort.users.count
        students_hash = {cohort.title => tot_students}
        cohorts_student.push students_hash
      end
      return cohorts_student
   end

  def hf_get_past_data
    past_data = Hash.new{ |h,k| h[k] = Hash.new 0 }
    ALLCOHORTS.each do |cohort|
        ["Past 2 Months", "Past 6 Months", "Past Year"].each do |item|
            past_data[cohort][item] = 0
        end
    end
    cohorts = Cohort.all.order('title ASC').includes(:users)
    cohorts.each do |cohort|
      if !cohort.title.include?  'Med18'
        cohort.users.each do |user|
          #if user.meetings.empty?
            temp_cohort = cohort.title.split(" - ").last
            past_data[temp_cohort]["Past 2 Months"] += user.meetings.where(created_at: 2.months.ago..Time.now).count
            past_data[temp_cohort]["Past 6 Months"] += user.meetings.where(created_at: 6.months.ago..Time.now).count
            if user.meetings.where(created_at: 1.year.ago..Time.now).count == 0
              past_data[temp_cohort]["Past Year"]     += 1
            end
          #end
       end
      end
    end
    return past_data
  end

  def hf_cds_reporting(user_id)
    uniq_subjects  = Coaching::Meeting.distinct.pluck(:subject)

    if user_id == 'All'
      cohorts = Cohort.all.order('title ASC').includes(:users)
    else
      cohorts  = Cohort.where(user_id: user_id).order('title ASC').includes(:users)
    end


    big_hash = Hash.new{ |h,k| h[k] = Hash.new 0 }
    ALLCOHORTS.each do |cohort|
        uniq_subjects.sort.each do |subject|
          if !subject.empty?
            big_hash[cohort][subject.first] = 0
          end
        end
    end
    #subject_hash = Hash.new 0
    cohorts.each do |cohort|
        cohort.users.each do |user|
            if !cohort.title.include?  'Med18'
              if !user.meetings.empty?
                #puts "cohort: " + cohort.title + " --> " + user.full_name
                #puts "subjects: " +  user.meetings.first.subject.map(&:inspect).join(',')
                subject = user.meetings.first.subject.map(&:inspect).join(',')
                if subject.to_s != ""
                  #subject_hash[subject] += 1
                  #puts "cohort.title --> " + cohort.title
                  temp_cohort = cohort.title.split(" - ").last
                  big_hash[temp_cohort][subject] += 1
                end
              end

            end

        end
    end
    big_hash = big_hash.sort_by{|k, v| k}.reverse
    return big_hash
  end

  def hf_get_coaches_not_met_past_2_months (user_id)
    coaches_have_not_met_2 = Hash.new{ |h,k| h[k] = Hash.new Array.new}
    have_not_met_2 = []
    ALLCOHORTS.each do |cohort|
        ["Have Not Met Past 2 Months", "Have Not Met Past 6 Months", "Have Not Met Past Year"].each do |subject|
            coaches_have_not_met_2[cohort][subject] = []
        end
    end
    have_not_met_2 = []

    if user_id == 'All'
      cohorts = Cohort.all.order('title ASC').includes(:users)
    else
      cohorts  = Cohort.where(user_id: user_id).order('title ASC').includes(:users)
    end
    cohorts.each do |cohort|
      cohort.users.each do |user|
        if !cohort.title.include?  'Med18'
          temp_cohort = cohort.title.split(" - ").last
          if user.meetings.where(created_at: 2.months.ago..Time.now).count == 0
            puts "cohort: " + cohort.title
            coaches_have_not_met_2[temp_cohort]["Have Not Met Past 2 Months"].push cohort.title + "/" + user.full_name
          end
        end
        # past_data[temp_cohort]["Past 6 Months"] += user.meetings.where(created_at: 6.months.ago..Time.now).count
        # if user.meetings.where(created_at: 1.year.ago..Time.now).count == 0
        #   past_data[temp_cohort]["Past Year"]     += 1
        # end
      end

    end

    return coaches_have_not_met_2 
  end
end
