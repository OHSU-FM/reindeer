require "spec_helper"

describe Assignment::AssignmentGroup do

  it "has a valid factory" do
    expect(create :assignment_group).to be_valid
  end

end
