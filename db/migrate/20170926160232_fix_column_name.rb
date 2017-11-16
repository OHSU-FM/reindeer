class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :goals, :type, :goal_type
  end
end
