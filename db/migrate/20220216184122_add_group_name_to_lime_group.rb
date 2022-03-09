class AddGroupNameToLimeGroup < ActiveRecord::Migration[6.1]
  def change
    add_column :lime_groups, :group_name, :string
  end
end
