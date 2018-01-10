class CommentThread < ActiveRecord::Base
  belongs_to :threadable, polymorphic: true
  belongs_to :first_user, foreign_key: :first_user_id, class_name: "User"
  belongs_to :second_user, foreign_key: :second_user_id, class_name: "User"

  has_many :comments, as: :commentable

  validates_presence_of :threadable, :first_user, :second_user

  def has_comments?
    !comments.empty?
  end
end
