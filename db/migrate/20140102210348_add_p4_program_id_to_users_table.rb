class AddP4ProgramIdToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :p4_program_id, :text
  end
end
