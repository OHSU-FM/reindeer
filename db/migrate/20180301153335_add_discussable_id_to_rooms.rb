class AddDiscussableIdToRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :discussable_id, :integer
    add_column :rooms, :discussable_type, :string

  end
end
