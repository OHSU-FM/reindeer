require "test_helper"

describe Assignment::AssignmentGroup < ActiveSupport::TestCase do
  let(:agt) { Assignment::AssignmentGroupTemplate.find(1) }
  let(:admin) { User.find(1) }
  let(:ag) { Assignment::AssignmentGroup.new }
  let(:agc) { agt.assignment_groups.create }

  it "must have an assignment_group_template" do
    ag.owner = admin
    value(ag).wont_be :valid?
  end

  it "must have an owner" do
    ag.assignment_group_template = agt
    value(ag).wont_be :valid?
  end

  it "should set some default values on create" do
    agc.title.must_be :==, "Winter 2015"
  end
end
