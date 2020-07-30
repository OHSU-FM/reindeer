class EpaReview < ApplicationRecord
    has_one :epa_reason
    belongs_to :reviewable, polymorphic: true

    def self.load_epa(epa_data, eg_full_name1, eg_full_name2)
      # epa_data is an ActionController Parameters tyoe
      keys = epa_data.keys
      keys.each do |key|
        email = epa_data["#{key}"]["email"]
        epa = epa_data["#{key}"]["epa"]
        comments = epa_data["#{key}"]["comments"]
        full_name = epa_data["#{key}"]["full_name"]
        user = User.find_by(email: email)
        epa_master = user.epa_masters.find_by(epa: epa)
        epa_review = user.epa_masters.find_by(epa: epa).epa_reviews.where(epa: epa)
        if !epa_review.empty?

          if full_name == epa_review.last.reviewer1
            old_comment = epa_review.last.general_comments1.nil? ? "" : epa_review.last.general_comments1 + "\n"
            epa_review.update(badge_decision1: 'Not Yet', general_comments1: old_comment + comments)
          else
            old_comment = epa_review.last.general_comments2.nil? ? "" : epa_review.last.general_comments2 + "\n"
            epa_review.update(badge_decision1: 'Not Yet', general_comments2: old_comment + comments)
          end
        else
            epa_review.create(review_date1: DateTime.now, reviewer1: eg_full_name1, reviewer2: eg_full_name2, epa: epa, badge_decision1: 'Not Yet', badge_decision2: 'Not Yet', general_comments1: comments)
        end
      end

    end

    def self.update_epa_master(reviewable_id, epa, badge_decision1, badge_decision2 )

       if badge_decision1 == "Badge" and badge_decision2 == "Badge"
         EpaMaster.where(id: reviewable_id, epa: epa).update(status: 'Badge', status_date: Time.now, expiration_date: DateTime.now.next_year(3).to_time)
       else
         EpaMaster.where(id: reviewable_id, epa: epa).update(status: nil, status_date: nil, expiration_date: nil)
       end
       return user_id = EpaMaster.where(id: reviewable_id).select(:user_id)
    end

    def self.load_eg_members(user)
      if File.file? (Rails.root + "public/epa_reviews/eg_cohorts.csv")
        eg_cohorts = []
        rows ||= CSV.foreach(Rails.root + "public/epa_reviews/eg_cohorts.csv", headers: true)
        rows.each do |row|
          eg_cohorts << row.to_hash
        end

        eg_full_name1 = eg_cohorts.collect{|e| e["eg_full_name1"] if e["email"] == user.email}.compact
        eg_full_name2 = eg_cohorts.collect{|e| e["eg_full_name2"] if e["email"] == user.email}.compact

        if eg_full_name1.blank? or eg_full_name2.blank?
          eg_full_name1 = eg_cohorts.collect{|e| e["eg_full_name1"]}.uniq
          eg_full_name2 = eg_cohorts.collect{|e| e["eg_full_name2"]}.uniq
        end

        return (eg_full_name1 + eg_full_name2).sort, eg_full_name1, eg_full_name2
      else
         return nil
      end

    end

    def self.execute_sql(*sql_array)
      connection.exec_query(send(:sanitize_sql_array, sql_array))
    end

    def self.get_max_date(user_id)
      sql = "select max(epa_reviews.updated_at)
	           FROM public.epa_reviews, epa_masters, users
	           where epa_masters.id = epa_reviews.reviewable_id and
		           epa_masters.user_id = #{user_id}"

      result ||= EpaReview.execute_sql(sql).to_hash

      return result.first["max"].to_date.strftime('%F')


    end

end
