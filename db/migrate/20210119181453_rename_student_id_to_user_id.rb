class RenameStudentIdToUserId < ActiveRecord::Migration[5.2]
  def change
    rename_column :events, :student_id, :user_id
  end
end
