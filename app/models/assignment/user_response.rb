class Assignment::UserResponse < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_assignment
  has_many :assignment_comments

end
