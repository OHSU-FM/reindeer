class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.string :the_name_of_it

      t.timestamps
    end
  end
end
