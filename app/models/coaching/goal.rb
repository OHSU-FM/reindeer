class Coaching::Goal < ApplicationRecord
  VALID_COMPETENCY_TAGS = ["pc", "pbli", "mk", "sbp", "p"]
  VALID_STATUSES = ["Not Started", "Needs Work", "On Track", "Completed"]

  belongs_to :user, required: true

  validates_presence_of :name, :target_date, :competency_tag, :g_status
  validates_length_of :name, maximum: 50
  validates :competency_tag, inclusion: { in: VALID_COMPETENCY_TAGS }
  validates :g_status, inclusion: { in: VALID_STATUSES }

  after_initialize :set_default_values

  paginates_per 10

  def self.search term
    self.where("name like ? OR description like ?", "%#{term}%", "%#{term}%")
  end

  private

  def set_default_values
    return unless g_status.nil?
    self.update(g_status: "Not Started")
  end
end
