class Advisor < ApplicationRecord
  belongs_to :user, optional: true
  has_many :meetings, class_name: 'Coaching::Meeting'
  has_many :events
end
