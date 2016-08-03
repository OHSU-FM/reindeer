class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  validates :user, presence: true
  validates :body, presence: true

  rails_admin do
    navigation_label 'Assignment'
  end

  ##############################################################################
  # :tagged_as possibilities
  # "sys"-- used to designate a comment as a "system level" comment. changes
  # css slightly, doesn't show user.display_name, though :user is still ag_owner
  ##############################################################################

  def row_partial_path
    flagged_as.nil? ? "comment_row" : "#{flagged_as}_comment_row"
  end
end
