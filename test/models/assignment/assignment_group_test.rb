require "test_helper"

class Assignment::AssignmentGroupTest < ActiveSupport::TestCase
  let(:agt) { assignment_assignment_group_templates(:one) }
  let(:admin) { users(:admin) }
  let(:ag) { Assignment::AssignmentGroup.new }
  let(:agc) { agt.assignment_groups.create }

  test "must have an assignment_group_template" do
    ag.owner = admin
    value(ag).wont_be :valid?
  end

  test "must have an owner" do
    ag.assignment_group_template = agt
    value(ag).wont_be :valid?
  end

  test "should set some default values on create" do
    agc.title.must_be :==, "a test assignment group template"
  end
end
