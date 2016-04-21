class DropAssignmentComments < ActiveRecord::Migration
  def change
    drop_table :assignment_comments
  end
end
