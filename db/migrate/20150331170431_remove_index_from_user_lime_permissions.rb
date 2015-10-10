class RemoveIndexFromUserLimePermissions < ActiveRecord::Migration
  def change
    remove_index :user_lime_permissions, :column => [:user_id, :role_aggregate_id]
  end
end
