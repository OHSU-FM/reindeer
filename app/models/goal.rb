class Goal < ActiveRecord::Base
  belongs_to :user
  has_many :action_plan_items, dependent: :destroy, inverse_of: :goal
  has_many :comments, as: :commentable

  accepts_nested_attributes_for :action_plan_items, allow_destroy: true, :reject_if => :all_blank
  validates_presence_of :title, :description, :target_date, :user

  ALLOWABLE_GOAL_TAGS = [
    "PC",
    "PBLI",
    "MK",
    "SBP",
    "P"
  ]

  ALLOWABLE_MEETING_TAGS = [nil]

  ALLOWABLE_GOAL_STATUSES = [
    "Not Started",
    "Needs Work",
    "On Track"
  ]

  ALLOWABLE_MEETING_STATUSES = [
    "Scheduled",
    "Skipped",
    "Passed"
  ]

  ALLOWABLE_TYPES = [
    "Goal",
    "Meeting"
  ]

  validates :tag, inclusion: { in: ALLOWABLE_GOAL_TAGS },
    if: Proc.new{ |a| a.type == 'Goal'}
  validates :status, inclusion: { in: ALLOWABLE_GOAL_STATUSES },
    if: Proc.new{ |a| a.type == 'Goal'}
  validates :type, inclusion: { in: ALLOWABLE_TYPES }
end
