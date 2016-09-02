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

  def self.update_associations
    to_update = all.select{|c|
      c.commentable_type == "Assignment::UserResponse" &&
      c.commentable.user_assignment.nil?
    }
    to_update.each do |c|
      ur = c.commentable
      new_ur = Assignment::UserResponse.where(title: ur.title,
                                            resp_type: ur.resp_type,
                                            content: ur.content)
        .sort_by{|ur| ur.id }.last
      c.commentable_id = new_ur.id
      c.save!
    end
  end

  def row_partial_path
    flagged_as.nil? ? "comment_row" : "#{flagged_as}_comment_row"
  end
end
