class AddLsListStateToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :ls_list_state, :string, default: "dirty"
  end
end
