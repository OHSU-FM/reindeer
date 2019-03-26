class CreateEpaMasters < ActiveRecord::Migration[5.2]
  def change
    create_table :epa_masters do |t|
      t.string   :epa
      t.datetime	 :review_date1
      t.string   :reviewed_by1a
      t.string   :reviewed_by1b
      t.string   :status1
      t.text 	   :note1
      t.datetime	 :review_date2
      t.string   :reviewed_by2a
      t.string   :reviewed_by2b
      t.string   :status2
      t.text 	   :note2
      t.datetime :review_date3
      t.string   :reviewed_by3a
      t.string   :reviewed_by3b
      t.string   :status3
      t.text 	 :note3
      t.references :user, foreign_key: true
      t.timestamps
    end
    add_index :epa_masters, [:user_id, :epa], :unique => true, :name => 'by_user_epas'
  end
end
