require "test_helper"

describe AssignmentGroup do
  let(:assignment_group) { AssignmentGroup.new }

  it "must be valid" do
    value(assignment_group).must_be :valid?
  end
end
