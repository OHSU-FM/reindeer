class AddPermissionGroupIdToMed23Mspes < ActiveRecord::Migration[7.0]
  def change
    add_column :med23_mspes, :permission_group_id, :integer
  end
end
