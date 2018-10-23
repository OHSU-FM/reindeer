class AddViewTypeToRoleAggregates < ActiveRecord::Migration[4.2]
  def change
    add_column :role_aggregates, :view_type, :string
  end
end
