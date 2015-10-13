class Assignment::AssignmentGroup < ActiveRecord::Base
  belongs_to :user
  has_many :survey_assignments
end
