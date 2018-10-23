class AddDefaultViewToRoleAggregates < ActiveRecord::Migration[4.2]
  def change
    add_column :role_aggregates, :default_view, :string
  end
end
