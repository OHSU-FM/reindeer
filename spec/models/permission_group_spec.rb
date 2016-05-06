require "rails_helper"

describe PermissionGroup do
  let(:coach_pg) { FactoryGirl.create(:coach_permission_group) }

  it "has pinned_survey_groups" do
    assert_equal coach_pg.pinned_survey_group_titles, ["test"]
  end
end
