class AddAutoPermissionsFlagToRoleAggregates < ActiveRecord::Migration
    def up
      add_column :role_aggregates, :managed_permissions, :boolean, :default => true
    end
    
    def down
      remove_column :role_aggregates, :managed_permissions
    end
end
