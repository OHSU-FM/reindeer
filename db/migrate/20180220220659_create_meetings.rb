class CreateMeetings < ActiveRecord::Migration[5.0]
  def change
    create_table :meetings do |t|
      t.string :subject
      t.datetime :date
      t.string :location
      t.string :status
      t.text :notes
      t.references :user

      t.timestamps
    end
  end
end
