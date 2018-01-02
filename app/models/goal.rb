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

  validates :tag, inclusion: { in: ALLOWABLE_GOAL_TAGS }
  validates :status, inclusion: { in: ALLOWABLE_GOAL_STATUSES }

  def get_no_comments (goal_id)

      commentable = Comment.where(commentable_id: goal_id)
      if !commentable.empty?
          return commentable.count.to_s
      else
          return ""
      end

  end

end
