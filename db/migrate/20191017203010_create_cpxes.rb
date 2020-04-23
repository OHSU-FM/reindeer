class CreateCpxes < ActiveRecord::Migration[5.2]
  def change
    create_table :cpxes do |t|
      t.references :user, index: true
      t.string :email
      t.string :full_name
      t.json :cpx_data
    end
    add_index :cpxes, :email, unique: true
  end
end
