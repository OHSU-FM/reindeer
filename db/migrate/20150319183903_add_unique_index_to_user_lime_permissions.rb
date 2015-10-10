class AddUniqueIndexToUserLimePermissions < ActiveRecord::Migration
  def change
    add_index :user_lime_permissions, [:user_id, :role_aggregate_id], unique: true
  end
end
