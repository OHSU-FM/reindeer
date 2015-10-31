class Assignment::AssignmentComment < ActiveRecord::Base
  belongs_to :user_assignment
  belongs_to :user
  belongs_to :assignment_group, inverse_of: :comments
  belongs_to :survey_assignment, inverse_of: :comments
  validates :slug, presence: true
end
