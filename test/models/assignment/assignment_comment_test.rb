require "test_helper"

describe Assignment::AssignmentComment do
  let(:assignment_comment) { Assignment::AssignmentComment.new }

  it "must be valid" do
    value(assignment_comment).must_be :valid?
  end
end
