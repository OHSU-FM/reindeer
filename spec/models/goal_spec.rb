require 'spec_helper'

RSpec.describe Goal, type: :model do
  it 'has a factory' do
    expect(build :goal).to be_valid
  end

  it 'requires a title' do
    expect(build :goal, title: nil).not_to be_valid
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
end
