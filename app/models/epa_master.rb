class EpaMaster < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, inverse_of: :epa_masters
  has_many   :epa_reviews, as: :reviewable,  dependent: :destroy
  accepts_nested_attributes_for :epa_reviews

  def full_name
    self.User.find(user_id)
  end

  rails_admin do
    list do
      field :id
      field :epa do
        searchable false
      end
      field :status do
        searchable false
      end
      field :user do
        pretty_value do
          value.full_name
        end
        searchable true
      end
    end
    # ...
  end

  def self.get_all_eg_cohorts(permission_group_id)
    results = EpaMaster.execute_sql("select user_id, eg_cohorts.permission_group_id, users.full_name,
        eg_cohorts.email, eg_full_name1, eg_email1, eg_full_name2, eg_email2
        from eg_cohorts, users
        where eg_cohorts.email = users.email and
        eg_cohorts.permission_group_id = ? order by users.full_name", permission_group_id.to_i).to_a

    return results

  end

  def self.get_eg_cohort(permission_group_id, current_user_email)
    results = EpaMaster.execute_sql("select user_id, eg_cohorts.permission_group_id, users.full_name,
        eg_cohorts.email, eg_full_name1, eg_email1, eg_full_name2, eg_email2
        from eg_cohorts, users
        where eg_cohorts.email = users.email and
        eg_cohorts.permission_group_id = ? and
        (eg_email1=? or eg_email2=?) order by users.full_name",permission_group_id, current_user_email, current_user_email).to_a

    return results

  end

  def self.update_not_yet_and_grounded_epas(permission_group_id)  #pemission_group looks like 'Med22'

    if permission_group_id.nil? or permission_group_id.include? 'Case'
      return
    end
    #permission_group_id = PermissionGroup.find(permission_group_id).id
    permission_group_id = permission_group_id.to_i

    result = EpaMaster.execute_sql("update epa_reviews set badge_decision1='Badge'
       from  epa_masters, users
	     where epa_masters.id = epa_reviews.reviewable_id and
          trust1='Grounded' and badge_decision1='Not Yet' and
		      users.id = epa_masters.user_id and
		      users.permission_group_id=?", permission_group_id).to_a

    result2 = EpaMaster.execute_sql("update epa_reviews set badge_decision2='Badge'
       from  epa_masters, users
	     where epa_masters.id = epa_reviews.reviewable_id and
          trust2='Grounded' and badge_decision2='Not Yet' and
		      users.id = epa_masters.user_id and
		      users.permission_group_id=?", permission_group_id).to_a


  end

  def badged?
     if (self.status == "Badge")
       return true
     else
       return false
     end
  end

  def self.execute_sql(*sql_array)
    connection.exec_query(send(:sanitize_sql_array, sql_array))
  end

  def self.get_epa_mismatch permission_group_id, eg_member
    # sql = "select em.id, em.user_id, users.full_name, em.epa, em.status, em.status_date " +
    #       "from epa_masters em, users " +
    #       "where users.id = em.user_id order by users.full_name, em.epa ASC"
    if eg_member == "All"
      results ||= EpaMaster.execute_sql("SELECT users.full_name, epa_reviews.epa,
            review_date1, reviewer1, badge_decision1, trust1, general_comments1, reason1,
            review_date2, reviewer2, badge_decision2, trust2, general_comments2, reason2
            	FROM public.epa_reviews, epa_masters, users
            	where epa_masters.id = epa_reviews.reviewable_id and
            	     badge_decision1 <> badge_decision2 and
            		  users.id = epa_masters.user_id and
            		  users.permission_group_id = ? order by full_name, epa", permission_group_id).to_a
    else
      results ||= EpaMaster.execute_sql("SELECT users.full_name, epa_reviews.epa,
            review_date1, reviewer1, badge_decision1, trust1, general_comments1, reason1,
            review_date2, reviewer2, badge_decision2, trust2, general_comments2, reason2
            	FROM public.epa_reviews, epa_masters, users
            	where (epa_reviews.reviewer1 = ? or epa_reviews.reviewer2  = ? ) and
                   epa_masters.id = epa_reviews.reviewable_id and
            	     badge_decision1 <> badge_decision2 and
            		  users.id = epa_masters.user_id and
            		  users.permission_group_id = ? order by full_name, epa", eg_member, eg_member, permission_group_id).to_a
    end

    #results = ActiveRecord::Base.connection.exec_query(sql)
    return results
  end

  def self.get_epa_badged permission_group_id
    if permission_group_id.to_i >= 20  # >= Med26
      results ||= EpaMaster.execute_sql("SELECT users.full_name, epa_reviews.epa,
            review_date1, reviewer1, badge_decision1, trust1, general_comments1, reason1,
            review_date2, reviewer2, badge_decision2, trust2, general_comments2, reason2
            	FROM public.epa_reviews, epa_masters, users
            	where epa_masters.id = epa_reviews.reviewable_id and
            	     badge_decision1 = 'Badge' and badge_decision2 = 'Badge' and
            		  users.id = epa_masters.user_id and
                  users.new_competency = true and
            		  users.permission_group_id = ? order by full_name, epa", permission_group_id).to_a
    else
      results ||= EpaMaster.execute_sql("SELECT users.full_name, epa_reviews.epa,
            review_date1, reviewer1, badge_decision1, trust1, general_comments1, reason1,
            review_date2, reviewer2, badge_decision2, trust2, general_comments2, reason2
            	FROM public.epa_reviews, epa_masters, users
            	where epa_masters.id = epa_reviews.reviewable_id and
            	     badge_decision1 = 'Badge' and badge_decision2 = 'Badge' and
            		  users.id = epa_masters.user_id and
            		  users.permission_group_id = ? order by full_name, epa", permission_group_id).to_a

    end

    #results = ActiveRecord::Base.connection.exec_query(sql)
    return results
  end


  def self.process_epa_badged in_data, permission_group_id
    epa_badged_count = {}
    if permission_group_id.to_i >= 20  # >= Med26
      #new EPAs
      count = in_data.collect{|val| val["badge_decision1"] if val["epa"] == "EPA1A" and val["badge_decision1"] == 'Badge'}.compact.count
      epa_badged_count.store("EPA1A", count)

      count = in_data.collect{|val| val["badge_decision1"] if val["epa"] == "EPA1B" and val["badge_decision1"] == 'Badge'}.compact.count
      epa_badged_count.store("EPA1B", count)

      for i in 2..11
        count = in_data.collect{|val| val["badge_decision1"] if val["epa"] == "EPA#{i}" and val["badge_decision1"] == 'Badge'}.compact.count
        epa_badged_count.store("EPA#{i}", count)
      end
    else
      for i in 1..13
        count = in_data.collect{|val| val["badge_decision1"] if val["epa"] == "EPA#{i}" and val["badge_decision1"] == 'Badge'}.compact.count
        epa_badged_count.store("EPA#{i}", count)
      end

    end

    students = []
    students_hash = {}
    students = in_data.collect{|val| val["full_name"]}.uniq
    students.each do |student|
      count = in_data.collect{|val| val["badge_decision1"] if val["full_name"] == student and val["badge_decision1"] == 'Badge'}.compact.count
      students_hash.store(student, count)
    end
    return epa_badged_count, students_hash

  end

  def self.process_all_cohorts permission_groups
    epa_badged_cohorts_hash = {}
    permission_groups.sort.each do |permission_group|
      epa_badged = get_epa_badged(permission_group.id)
      epa_badged_count, student_epa_count = process_epa_badged epa_badged, permission_group.id
      cohort_title = permission_group.title.split(" ").last.gsub(/[()]/, "")
      epa_badged_cohorts_hash.store(cohort_title, epa_badged_count)

    end
    return epa_badged_cohorts_hash
  end

  def self.process_all_cohorts_wba_epa(permission_groups)
    wba_epa_cohorts_hash = {}
    permission_groups.sort.each do |permission_group|
      cohort_title = permission_group.title.split(" ").last.gsub(/[()]/, "")
        results = EpaMaster.execute_sql("select epa, count(epa) as tot_epa
                                        from epas, users
                                        where users.id = user_id and
                                        involvement=4 and
                                        users.permission_group_id = ?
                                        group by epa
                                        order by epa ", permission_group.id)


      wba_epa_cohorts_hash.store(cohort_title, results.rows.to_h)
    end
    return wba_epa_cohorts_hash
  end

  def self.split_epa1(user)

    file = File.new("#{Rails.root}/log/eg_migration.log", "a")
    # Write content to the file
    if user.epa_masters.find_by(epa: 'EPA1A')
      file.puts ("student: #{user.full_name} --> found EPA1A --> no conversion!")
      file.puts ("--------------------------------------------------------------")
      return
    end

    file.puts ("conversion starts....student: #{user.full_name} email: #{user.email}-id: #{user.id}")
    epa_master_epa1b = user.epa_masters.find_by(epa: 'EPA1')
    epa_review_epa1b = user.epa_masters.find_by(epa: 'EPA1').epa_reviews.where(epa: 'EPA1')
    epa_master_epa1b.epa = "EPA1B"

    #{}"epa"=>"EPA1B", "status"=>"Not Yet", "status_date"=>nil, "expiration_date"=>nil, "user_id"=>1760,
    #the code here is working
    EpaMaster.find_or_create_by(epa: epa_master_epa1b.epa,
                  status: epa_master_epa1b.status,
                  status_date: epa_master_epa1b.status_date,
                  expiration_date: epa_master_epa1b.expiration_date,
                  user_id: epa_master_epa1b.user_id)
    file.puts "epa_master for EPA1B is created and saved!"

    epa_master_epa1b = user.epa_masters.find_by(epa: 'EPA1B')
    reviewable = EpaMaster.find(epa_master_epa1b.id)
    epa_review = reviewable.epa_reviews.new
    epa_review.epa = epa_master_epa1b.epa
    epa_review.review_date1 = epa_review_epa1b.first.review_date1
    epa_review.review_date2= epa_review_epa1b.first.review_date2
    epa_review.reviewer1 = epa_review_epa1b.first.reviewer1
    epa_review.reviewer2 = epa_review_epa1b.first.reviewer2
    epa_review.reason1 = epa_review_epa1b.first.reason1
    epa_review.reason2 = epa_review_epa1b.first.reason2
    epa_review.badge_decision1 = epa_review_epa1b.first.badge_decision1
    epa_review.trust1 = epa_review_epa1b.first.trust1
    epa_review.trust2 = epa_review_epa1b.first.trust2
    epa_review.student_comments1 = epa_review_epa1b.first.student_comments1
    epa_review.student_comments2 = epa_review_epa1b.first.student_comments2
    epa_review.evidence1 = epa_review_epa1b.first.evidence1
    epa_review.evidence2 = epa_review_epa1b.first.evidence2
    if epa_review.save
      file.puts "EpaReview for EPA1B is created and saved!"
    end

    epa_review_epa1a = user.epa_masters.find_by(epa: 'EPA1').epa_reviews.where(epa: 'EPA1').update(epa: 'EPA1A')
    epa1a = user.epa_masters.find_by(epa: 'EPA1').update(epa: 'EPA1A')
    file.puts "Renamed EPA1 to EPA1A for epa_master and epa_review"

    epa12 = user.epa_masters.find_by(epa: 'EPA12', status: [nil,'Not Yet'])
    if !epa12.nil?
      epa12.destroy
     file.puts "Removed EPA12 from epa_masters and epa_reviews!"
    else
      file.puts "Found Badged EPA12 --> Not Deleted!!"
    end
    epa13 = user.epa_masters.find_by(epa: 'EPA13', status: [nil,'Not Yet'])
    if !epa13.nil?
      epa13.destroy
      file.puts "Removed EPA13 from epa_masters and epa_reviews!"
    else
      file.puts "Found Badged EPA13 --> Not Deleted!!"
    end

    file.puts "----------------------------------------------------------"

    file.close

  end

end
