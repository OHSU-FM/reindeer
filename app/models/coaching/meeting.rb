class Coaching::Meeting < ApplicationRecord
  has_paper_trail

  VALID_STATUSES = ["Scheduled", "Completed", "Meeting Canceled", "No Show", "Rescheduled"]

  belongs_to :user, required: true
  #has_one :event

  has_one :room, as: :discussable
  has_one :event
  has_one :advisor
  validates_presence_of :subject, :date, :m_status, :location, :event_id
  validates :m_status, inclusion: { in: VALID_STATUSES }

  after_initialize :set_default_values, :set_default_values_for_meeting

  paginates_per 6

  def self.search term
    self.where("array_to_string(subject, ',') like ? OR notes like ?", "%#{term}%", "%#{term}%")
  end


  private

  def set_default_values
    return unless m_status.nil?
    update(m_status: "Scheduled")
  end

  def set_default_values_for_meeting
    return unless room.nil?
    if !self.id.nil?
      Room.create(discussable: self, identifier: "meeting_room_#{self.id}")
    end
  end
end
