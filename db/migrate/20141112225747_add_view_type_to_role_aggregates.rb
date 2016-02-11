class AddViewTypeToRoleAggregates < ActiveRecord::Migration
  def change
    add_column :role_aggregates, :view_type, :string
  end
end
