require 'rails_helper'

RSpec.describe Coaching::Meeting, type: :model do
  describe "validations:" do
    it "requires a user" do
      expect(build(:meeting, user: nil)).not_to be_valid
    end

    it "requires a name" do
      expect(build(:meeting, subject: nil)).not_to be_valid
    end

    it "requires a date" do
      expect(build(:meeting, date: nil)).not_to be_valid
    end

    it "requires a location" do
      expect(build(:meeting, location: nil)).not_to be_valid
    end

    it "requires that target_date be a date" do
      expect(build(:meeting, date: 'huh?')).not_to be_valid
    end

    it "requires a m_status" do
      expect(build(:meeting, m_status: nil)).not_to be_valid
    end

    it "requires a valid m_status" do
      Coaching::Meeting::VALID_STATUSES.each do |status|
        expect(build(:meeting, m_status: status)).to be_valid
      end
      expect(build(:meeting, m_status: 'some other status')).not_to be_valid
    end
  end

  it "initializes with scheduled status" do
    expect(create(:meeting).m_status).to eq "Scheduled"
  end

  describe "methods" do
    it "#search returns meetings belonging to the user that match the terms" do
      m = create :meeting, user: (create :student), subject: "i belong to student"
      student = m.user
      another_users_m = create :meeting, notes: 'i belong to someone else'
      expect(student.meetings.search('belong')).to include m
      expect(student.meetings.search('belong')).not_to include another_users_m
    end
  end
end
