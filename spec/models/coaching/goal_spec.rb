require 'rails_helper'

RSpec.describe Coaching::Goal, type: :model do
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
      Coaching::Goal::VALID_COMPETENCY_TAGS.each do |tag|
        expect(build(:goal, competency_tag: tag)).to be_valid
      end
      expect(build(:goal, competency_tag: 'some other tag')).not_to be_valid
    end

    it "requires a g_status" do
      expect(build(:goal, g_status: nil)).not_to be_valid
    end

    it "requires a valid g_status" do
      Coaching::Goal::VALID_STATUSES.each do |status|
        expect(build(:goal, g_status: status)).to be_valid
      end
      expect(build(:goal, competency_tag: 'some other tag')).not_to be_valid
    end
  end

  it "initializes with not started g_status" do
    expect(create(:goal).g_status).to eq "Not Started"
  end

  describe "methods" do
    it "#search returns goals belonging to the user that match the terms" do
      g = create :goal, user: (create :student), name: "i belong to student"
      student = g.user
      another_users_goal = create :goal, description: 'i belong to someone else'
      expect(student.goals.search('belong')).to include g
      expect(student.goals.search('belong')).not_to include another_users_goal
    end
  end
end
