class CreatePrecepMeetings < ActiveRecord::Migration[8.0]
  def change
    create_table :precep_meetings do |t|
      t.references :user, index: true, foreign_key: true
      t.string :student_sid
      t.string :student_name
      t.datetime :meeting_date
      t.string :meeting_notes
      t.string :meeting_with
      t.string :other_present

      t.timestamps
    end
  end
end
