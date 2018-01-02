class ActionPlanItem < ActiveRecord::Base
  belongs_to :goal
  validates_presence_of :description
end
