class AddStudentIdToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :student_id, :integer
    add_index :events, [:student_id, :id]
  end
end
