class AddColumnsToGoal < ActiveRecord::Migration
  def change
    add_column :goals, :type, :string
    add_column :goals, :location, :string
  end
end
