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

    def self.load_eg_members
      if File.file? (Rails.root + "public/epa_reviews/eg_members.json")
        json_obj = File.read(Rails.root + "public/epa_reviews/eg_members.json")
        eg_members = JSON.parse(json_obj).map{|e| e["eg_member"]}

      else
         return nil
      end

    end

end
