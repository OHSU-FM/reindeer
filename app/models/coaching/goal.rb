class Coaching::Goal < ApplicationRecord
  VALID_COMPETENCY_TAGS = ["pc", "pbli", "mk", "sbp", "p"]
  VALID_STATUSES = ["Not Started", "Needs Work", "On Track", "Completed"]

  belongs_to :user, required: true

  validates_presence_of :name, :target_date, :competency_tag, :status
  validates :competency_tag, inclusion: { in: VALID_COMPETENCY_TAGS }
  validates :status, inclusion: { in: VALID_STATUSES }

  after_initialize :set_default_values

  private

  def set_default_values
    return unless status.nil?
    update(status: "Not Started")
  end
end
