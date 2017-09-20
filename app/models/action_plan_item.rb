class ActionPlanItem < ActiveRecord::Base
  attr_accessible :id, :description, :goal_id
  belongs_to :goal
  validates_presence_of :description

end
