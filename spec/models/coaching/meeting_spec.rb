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

    it "requires a status" do
      expect(build(:meeting, status: nil)).not_to be_valid
    end

    it "requires a valid status" do
      Coaching::Meeting::VALID_STATUSES.each do |status|
        expect(build(:meeting, status: status)).to be_valid
      end
      expect(build(:meeting, status: 'some other status')).not_to be_valid
    end
  end

  it "initializes with scheduled status" do
    expect(create(:meeting).status).to eq "Scheduled"
  end
end
