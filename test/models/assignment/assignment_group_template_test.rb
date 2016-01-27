require "test_helper"

describe Assignment::AssignmentGroupTemplate do
  let(:assignment_group_template) { Assignment::AssignmentGroupTemplate.new }

  it "must be valid" do
    value(assignment_group_template).must_be :valid?
  end
end
