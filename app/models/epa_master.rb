class EpaMaster < ApplicationRecord
  belongs_to :user, inverse_of: :epa_masters
  has_many   :epa_reviews, as: :reviewable,  dependent: :destroy
  accepts_nested_attributes_for :epa_reviews

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

  def self.get_epa_mismatch permission_group_id
    # sql = "select em.id, em.user_id, users.full_name, em.epa, em.status, em.status_date " +
    #       "from epa_masters em, users " +
    #       "where users.id = em.user_id order by users.full_name, em.epa ASC"

    results ||= EpaMaster.execute_sql("SELECT users.full_name, epa_reviews.epa,
          review_date1, reviewer1, badge_decision1, trust1, general_comments1, reason1,
          review_date2, reviewer2, badge_decision2, trust2, general_comments2, reason2
          	FROM public.epa_reviews, epa_masters, users
          	where epa_masters.id = epa_reviews.reviewable_id and
          	     badge_decision1 <> badge_decision2 and
          		  users.id = epa_masters.user_id and
          		  users.permission_group_id = ? order by full_name, epa", permission_group_id).to_hash

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
          		  users.permission_group_id = ? order by full_name, epa", permission_group_id).to_hash

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

end
