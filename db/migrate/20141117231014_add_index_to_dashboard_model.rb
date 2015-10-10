class AddIndexToDashboardModel < ActiveRecord::Migration
  def up
      add_index :dashboards, :user_id
  end

  def down
      remove_index :dashboards, :user_id
  end
end
