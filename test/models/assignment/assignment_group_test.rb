require "test_helper"

describe Assignment::AssignmentGroup do
  subject { FactoryGirl.build(:assignment_group) }

  it "has a valid factory" do
    subject.valid?.must_equal true
  end

end
