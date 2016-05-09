require 'rails_helper'

describe Assignment::UserAssignment do

  it "has a factory" do
    expect(create :user_assignment).to be_valid
  end
end
