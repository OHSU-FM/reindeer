require "test_helper"

describe Assignment::AssignmentGroup do
  let(:agt) { Assignment::AssignmentGroupTemplate.find(1) }
  let(:assignment_group) {
    binding.pry
    Assignment::AssignmentGroup.create(:assignment_assignment_group => agt)
  }

  it "must be valid" do
    value(assignment_group).must_be :valid?
  end
end
