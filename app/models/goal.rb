class Goal < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :description, :target_date, :user
end
