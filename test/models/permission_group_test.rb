require "test_helper"

class PermissionGroupTest < ActiveSupport::TestCase
  let(:coach_pg) { permission_groups(:coach_permission_group) }

  test "has pinned_survey_groups" do
    assert_equal coach_pg.pinned_survey_group_titles, ["test"]
  end
end
