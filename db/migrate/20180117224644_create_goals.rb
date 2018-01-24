class CreateGoals < ActiveRecord::Migration[5.0]
  def change
    create_table :goals do |t|
      t.string :name, null: false
      t.text :description
      t.string :status
      t.string :competency_tag
      t.datetime :target_date
      t.references :user, null: false

      t.timestamps
    end
  end
end
