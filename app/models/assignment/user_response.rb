class Assignment::UserResponse < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_assignment
  has_many :comments, as: :commentable
  delegate :user, to: :user_assignment
  validates :user_assignment, presence: true

  def assignment_group
    user_assignment.survey_assignment.assignment_group
  end

end
