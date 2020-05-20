class EpaReview < ApplicationRecord
    belongs_to :reviewable, polymorphic: true

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
        return (eg_full_name1 + eg_full_name2).sort
      else
         return nil
      end

    end

end
