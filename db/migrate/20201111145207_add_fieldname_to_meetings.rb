class AddFieldnameToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :advisor_type, :string
    add_column :meetings, :advisor_id, :integer
    add_column :meetings, :appointment_id, :integer
  end
end
