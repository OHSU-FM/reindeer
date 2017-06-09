class CreateCsvSources < ActiveRecord::Migration
  def change
    create_table :csv_sources do |t|
      t.string :field1
      t.integer :field2
      t.datetime :field3

      t.timestamps null: false
    end
  end
end
