class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true

  def user
    User.find(user_id)
  end
end
