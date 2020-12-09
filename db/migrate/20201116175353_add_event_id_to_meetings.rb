class AddEventIdToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :event_id, :integer
  end
end
