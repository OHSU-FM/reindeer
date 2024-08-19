class AddGraduatedStudentToMeeting < ActiveRecord::Migration[7.1]
  def change
    add_column :meetings, :graduated_student, :boolean
  end
end
