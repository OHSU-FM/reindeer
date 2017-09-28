require 'spec_helper'

RSpec.describe Goal, type: :model do
  it 'has a factory' do
    expect(create :goal).to be_valid
  end

  it 'requires a title' do
    expect(build :goal, title: nil).not_to be_valid
  end

  it 'requires a status' do
    expect(build :goal, status: nil).not_to be_valid
    expect(build :goal, status: "test").not_to be_valid
    Goal::ALLOWABLE_GOAL_STATUSES.each do |status|
      expect(create :goal, type: 'Goal', status: status).to be_valid
    end
  end

  it 'requires a description' do
    expect(build :goal, description: nil).not_to be_valid
  end

  it 'requires a target_date' do
    expect(build :goal, target_date: nil).not_to be_valid
  end

  it 'belongs to a user' do
    expect(build :goal, user: nil).not_to be_valid
  end

  it 'requires a location' do
    expect(build :goal, location: nil).to be_valid
  end

  it 'has valid type' do
    expect(build :goal, type: nil).not_to be_valid
    expect(build :goal, type: "test").not_to be_valid
    Goal::ALLOWABLE_TYPES.each do |type|
      expect(create :goal, type: type).to be_valid
    end
  end

  it 'has valid tag' do
    expect(build :goal, tag: 'test').not_to be_valid
    Goal::ALLOWABLE_MEETING_TAGS.each do |tag|
      expect(create :goal, type: 'Meeting', tag: tag).to be_valid
    end
  end

  describe "relationships" do
    it 'has_many comments' do
      goal = create :goal
      comment = create :comment, commentable: goal
      goal.reload
      expect(goal.comments).to include comment
    end
  end
end
