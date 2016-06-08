class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  validates :user, presence: true
  validates :body, presence: true

  rails_admin do
    navigation_label 'Assignment'
  end
end
