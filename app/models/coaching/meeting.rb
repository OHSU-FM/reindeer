class Coaching::Meeting < ApplicationRecord
  VALID_STATUSES = ["Scheduled", "Passed", "Skipped", "Rescheduled"]

  belongs_to :user, required: true

  validates_presence_of :subject, :date, :m_status, :location
  validates :m_status, inclusion: { in: VALID_STATUSES }

  after_initialize :set_default_values

  paginates_per 10

  private

  def set_default_values
    return unless m_status.nil?
    update(m_status: "Scheduled")
  end
end
