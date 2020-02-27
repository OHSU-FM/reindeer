class AddattendingFacultyEpas < ActiveRecord::Migration[5.2]
  def change
    add_column :epas, :attending_faculty, :boolean
  end
end
