module CdsReportsHelper

  def hf_cds_reporting

    uniq_subjects  = Coaching::Meeting.distinct.pluck(:subject)

    cohorts = Cohort.all.order('title ASC').includes(:users)
    big_hash = Hash.new{ |h,k| h[k] = Hash.new 0 }

    temp_hash = {}
    ["Med22", "Med21", "Med20", "Med19"].each do |cohort|
        uniq_subjects.sort.each do |subject|
          if !subject.empty?
            big_hash[cohort][subject.first] = 0
          end
        end
    end

    #subject_hash = Hash.new 0
    cohorts.each do |cohort|
        cohort.users.each do |user|
            if !user.meetings.empty?
              if !cohort.title.include?  'Med18'
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
    #big_hash["Med19"] = subject_hash

    big_hash = big_hash.sort_by{|k, v| k}.reverse


    return big_hash

  end
end
