class CreateEgMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :eg_members do |t|
      t.string :full_name
      t.string :email
      t.string :eg_type
      t.boolean :active

      t.timestamps
    end
  end
end
