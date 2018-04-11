class Coaching::Goal < ApplicationRecord
  VALID_COMPETENCY_TAGS = ["pc", "pbli", "mk", "sbp", "p"]
  VALID_STATUSES = ["Not Started", "Needs Work", "On Track", "Completed"]

  belongs_to :user, required: true
  has_one :room, as: :discussable

  validates_presence_of :name, :target_date, :competency_tag, :g_status
  validates_length_of :name, maximum: 50
  validates :competency_tag, inclusion: { in: VALID_COMPETENCY_TAGS }
  validates :g_status, inclusion: { in: VALID_STATUSES }

  after_initialize :set_default_values, :set_default_values_for_room

  scope :completed, -> { where(g_status: "Completed") }

  paginates_per 6

  def self.search term
    self.where("name like ? OR description like ?", "%#{term}%", "%#{term}%")
  end

  def self.completed_for_user bool
    bool ? self.where(g_status: "Completed") : self.where
  end

  private

  def set_default_values
    return unless g_status.nil?
    self.update(g_status: "Not Started")
  end

  def set_default_values_for_room
    return unless room.nil?
    if !self.id.nil?
      Room.create(discussable: self, identifier: "goal_room_#{self.id}")
    end
  end

end
