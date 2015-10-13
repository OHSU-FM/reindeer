class Assignment::AssignmentComment < ActiveRecord::Base
  belongs_to :user_assignment
  belongs_to :user
  validates :slug, presence: true
end
