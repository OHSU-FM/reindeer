class CreateBadgingDates < ActiveRecord::Migration[7.1]
  def change
    create_table :badging_dates do |t|
      t.integer :permission_group_id
      t.date :release_date
      t.date :last_review_end_date
      t.date :next_review_end_date

      t.timestamps
    end
  end
end
