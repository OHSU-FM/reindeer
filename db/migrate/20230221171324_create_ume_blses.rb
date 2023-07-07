class CreateUmeBlses < ActiveRecord::Migration[6.1]
  def change
    create_table :ume_blses do |t|
      t.references :user
      t.date :expiration_date
      t.string :comments
      t.timestamps
    end
  end
end
