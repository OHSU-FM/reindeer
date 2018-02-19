require 'rails_helper'

RSpec.describe Goal, type: :model do
  describe "validations:" do
    it "requires a user" do
      expect(build(:goal, user: nil)).not_to be_valid
    end

    it "requires a name" do
      expect(build(:goal, name: nil)).not_to be_valid
    end

    it "requires a target_date" do
      expect(build(:goal, target_date: nil)).not_to be_valid
    end

    it "requires that target_date be a date" do
      expect(build(:goal, target_date: 'huh?')).not_to be_valid
    end

    it "requires a competency_tag" do
      expect(build(:goal, competency_tag: nil)).not_to be_valid
    end

    it "requires a valid competency_tag" do
      Goal::VALID_COMPETENCY_TAGS.each do |tag|
        expect(build(:goal, competency_tag: tag)).to be_valid
      end
      expect(build(:goal, competency_tag: 'some other tag')).not_to be_valid
    end

    it "requires a status" do
      expect(build(:goal, status: nil)).not_to be_valid
    end

    it "requires a valid status" do
      Goal::VALID_STATUSES.each do |status|
        expect(build(:goal, status: status)).to be_valid
      end
      expect(build(:goal, competency_tag: 'some other tag')).not_to be_valid
    end
  end

  it "initializes with not started status" do
    expect(create(:goal).status).to eq "Not Started"
  end
end
