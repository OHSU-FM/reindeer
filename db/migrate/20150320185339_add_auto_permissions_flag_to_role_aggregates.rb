class AddAutoPermissionsFlagToRoleAggregates < ActiveRecord::Migration[4.2]
    def up
      add_column :role_aggregates, :managed_permissions, :boolean, :default => true
    end
    
    def down
      remove_column :role_aggregates, :managed_permissions
    end
end
