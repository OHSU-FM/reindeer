class DropUniqueFromUserAssignments < ActiveRecord::Migration
  def change
    remove_index :user_assignments, name: :uniq_sid_by_user
  end
end
