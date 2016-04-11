class Assignment::AssignmentComment < ActiveRecord::Base
  include Assignment::MarkdownFilter
  markdown_columns :slug_md

  belongs_to :user_assignment
  belongs_to :user
  belongs_to :assignment_group, inverse_of: :comments
  belongs_to :user_response, inverse_of: :comments
  validates :slug_md, presence: true


end
