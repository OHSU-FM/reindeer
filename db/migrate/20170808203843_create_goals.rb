class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :title
      t.text :description
      t.string :tag
      t.string :status
      t.date :target_date
      t.references :user

      t.timestamps null: false
    end
  end
end
