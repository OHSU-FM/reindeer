class AddPinnedRoleAggregateGroupsToPermissionGroups < ActiveRecord::Migration
  def change
    add_column :permission_groups, :pinned_survey_group_titles, :text
  end
end
