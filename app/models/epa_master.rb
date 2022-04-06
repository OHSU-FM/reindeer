class EpaMaster < ApplicationRecord
  belongs_to :user, inverse_of: :epa_masters
  has_many   :epa_reviews, as: :reviewable,  dependent: :destroy
  accepts_nested_attributes_for :epa_reviews

  def self.update_not_yet_and_grounded_epas(cohort_group)  #pemission_group looks like 'Med22'

    if cohort_group.nil? or cohort_group.include? 'Case'
      return
    end
    permission_group_id = PermissionGroup.where("title like ?", "%#{cohort_group}%").first.id

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
    results ||= EpaMaster.execute_sql("SELECT users.full_name, epa_reviews.epa,
          review_date1, reviewer1, badge_decision1, trust1, general_comments1, reason1,
          review_date2, reviewer2, badge_decision2, trust2, general_comments2, reason2
          	FROM public.epa_reviews, epa_masters, users
          	where epa_masters.id = epa_reviews.reviewable_id and
          	     badge_decision1 = 'Badge' and badge_decision2 = 'Badge' and
          		  users.id = epa_masters.user_id and
          		  users.permission_group_id = ? order by full_name, epa", permission_group_id).to_a

    #results = ActiveRecord::Base.connection.exec_query(sql)
    return results
  end


  def self.process_epa_badged in_data
    epa_badged_count = {}
    for i in 1..13
      count = in_data.collect{|val| val["badge_decision1"] if val["epa"] == "EPA#{i}" and val["badge_decision1"] == 'Badge'}.compact.count
      epa_badged_count.store("EPA#{i}", count)
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
      epa_badged_count, student_epa_count = process_epa_badged epa_badged
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

end
