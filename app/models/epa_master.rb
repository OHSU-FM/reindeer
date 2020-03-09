class EpaMaster < ApplicationRecord
  belongs_to :user
  has_many   :epa_reviews, as: :reviewable,  dependent: :destroy
  accepts_nested_attributes_for :epa_reviews

  def badged?
     if (self.status == "Badge")
       return true
     else
       return false
     end
  end

  
end
