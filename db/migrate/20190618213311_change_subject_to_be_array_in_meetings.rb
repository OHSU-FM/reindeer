class ChangeSubjectToBeArrayInMeetings < ActiveRecord::Migration[5.2]

  def up
    change_column :meetings, :subject, :string, array: true, using: "(string_to_array(subject, ','))"
  end

  def down
    change_column :meetings, :subject, :string, array: false, using: "(array_to_string(subject, ','))"
  end
end
