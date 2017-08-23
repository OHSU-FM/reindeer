require 'spec_helper'

RSpec.describe ActionPlanItem, type: :model do
  it 'has a factory' do
    expect(create :action_plan_item).to be_valid
  end

  it 'requires a description' do
    expect(build :action_plan_item, description: nil).not_to be_valid
  end
end
