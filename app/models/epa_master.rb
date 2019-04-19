class EpaMaster < ApplicationRecord
    #self.primary_key = [:user_id, :epa]
    belongs_to :user
    has_many   :epa_reviews, as: :reviewable,  dependent: :destroy
    accepts_nested_attributes_for :epa_reviews

    def statuses?
       if (self.status == "Badged")
         return true
       else
         return false
       end
    end

end
