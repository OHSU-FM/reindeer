class CreateOnTimeStarts < ActiveRecord::Migration
  def change
    create_table :on_time_starts do |t|
      t.string :provider
      t.string :site
      t.integer :total_first_cases
      t.integer :late_starts
      t.integer :on_time_starts
      t.float :pct_on_time

      t.timestamps null: false
    end
  end
end
