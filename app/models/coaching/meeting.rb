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
  after_initialize :set_default_values
    #:set_default_values_for_meeting

  paginates_per 10

  def self.search term
    self.where("array_to_string(subject, ',') like ? OR notes like ?", "%#{term}%", "%#{term}%")
  end


  def self.convert_to_json (params)
    nbme_form = []
    uworld_info = []
    q_bank_info = []

    params.each do |hash|
      hash.each do |key, val|
        if key.include? "nbme_" and val != ""
            nbme_form << hash
        elsif key.include? "uworld_" and val != ""
          uworld_info << hash
        elsif key.include? "q_bank_" and val != ""
          q_bank_info << hash
        end
      end
    end

    ## to remove backslash and the double quotes on the first and the last positions
    nbme_form_json = nbme_form.to_h.to_json
    uworld_info_json = uworld_info.to_h.to_json
    qbank_info_json = q_bank_info.to_h.to_json

    return nbme_form_json, uworld_info_json, qbank_info_json

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
