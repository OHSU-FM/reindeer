class Goal < ActiveRecord::Base
  belongs_to :user
  has_many :action_plan_items

  validates_presence_of :title, :description, :target_date, :user

  ALLOWABLE_TAGS = [
    "PC",
    "PBLI",
    "MK",
    "SBP",
    "P",
    nil
  ]

  validates :tag, inclusion: { in: ALLOWABLE_TAGS }

end
