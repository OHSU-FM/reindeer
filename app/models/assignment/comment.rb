class Assignment::Comment < ActiveRecord::Base
  self.table_name = 'assignment_comments'
  belongs_to :user_assignment
  belongs_to :user
  validates :slug, presence: true
end
