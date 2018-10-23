class AddPinnedRoleAggregateGroupsToPermissionGroups < ActiveRecord::Migration[4.2]
  def change
    add_column :permission_groups, :pinned_survey_group_titles, :text
  end
end
