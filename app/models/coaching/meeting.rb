class Coaching::Meeting < ApplicationRecord
  VALID_STATUSES = ["Scheduled", "Passed", "Skipped", "Rescheduled"]

  belongs_to :user, required: true

  validates_presence_of :subject, :date, :status, :location
  validates :status, inclusion: { in: VALID_STATUSES }

  after_initialize :set_default_values

  private

  def set_default_values
    return unless status.nil?
    update(status: "Scheduled")
  end
end
