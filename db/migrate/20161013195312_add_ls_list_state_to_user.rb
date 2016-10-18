class AddLsListStateToUser < ActiveRecord::Migration
  def change
    add_column :users, :ls_list_state, :string, default: "dirty"
  end
end
