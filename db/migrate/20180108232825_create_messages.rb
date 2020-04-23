class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :content
      t.boolean :archived, default: false
      t.belongs_to :user
      t.belongs_to :room

      t.timestamps
    end
  end
end
