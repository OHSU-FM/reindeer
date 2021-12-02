class RemoveAppointmentIdFromMeetings < ActiveRecord::Migration[5.2]
  def change
    remove_column :meetings, :appointment_id, :integer
  end
end
