class EpaReview < ApplicationRecord
  belongs_to :reviewable, polymorphic: true

end
