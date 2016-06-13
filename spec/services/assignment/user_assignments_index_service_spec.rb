require "spec_helper"

describe Assignment::UserAssignmentsIndexService do

  it "initializes with an assignment_group and params" do
    ag = create :assignment_group
    params = { user_id: ag.owner.id }
    service = Assignment::UserAssignmentsIndexService.new(ag, params)

    expect service
  end

end
