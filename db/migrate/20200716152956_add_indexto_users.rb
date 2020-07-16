class AddIndextoUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :sid, unique: true 
  end
end
