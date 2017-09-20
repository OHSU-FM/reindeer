class Goal < ActiveRecord::Base
  belongs_to :user
  has_many :action_plan_items, dependent: :destroy, inverse_of: :goal
  has_many :comments, as: :commentable 

  accepts_nested_attributes_for :action_plan_items, allow_destroy: true, :reject_if => :all_blank
  validates_presence_of :title, :description, :target_date, :user

  ALLOWABLE_TAGS = [
    "PC",
    "PBLI",
    "MK",
    "SBP",
    "P",
    nil
  ]

  ALLOWABLE_STATUSES = [
    "Not Started",
    "Needs Work",
    "On Track",
    "Scheduled",
    "Skipped",
    "Passed"
  ]

  ALLOWABLE_TYPES = [
    "Goal",
    "FoF"
  ]

  validates :tag, inclusion: { in: ALLOWABLE_TAGS }
  validates :status, inclusion: { in: ALLOWABLE_STATUSES }
  validates :type, inclusion: { in: ALLOWABLE_TYPES }

end
