class AddPrevPermisisonGroupIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :prev_permission_group_id, :integer
  end
end
