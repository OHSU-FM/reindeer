require "test_helper"

describe AssignmentComment do
  let(:assignment_comment) { AssignmentComment.new }

  it "must be valid" do
    value(assignment_comment).must_be :valid?
  end
end
