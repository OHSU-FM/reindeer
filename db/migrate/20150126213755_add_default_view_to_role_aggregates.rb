class AddDefaultViewToRoleAggregates < ActiveRecord::Migration
  def change
    add_column :role_aggregates, :default_view, :string
  end
end
