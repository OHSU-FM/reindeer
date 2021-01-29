class AddAcademicDiscussedOtherToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :academic_discussed_other, :string
    add_column :meetings, :academic_outcomes_other, :string
    add_column :meetings, :career_discussed_other, :string
    add_column :meetings, :career_outcomes_other, :string
    add_column :meetings, :advisor_notes, :text
    add_index :meetings, [:advisor_id, :id], unique: true
    add_index :meetings, [:event_id, :id], unique: true
  end
end
