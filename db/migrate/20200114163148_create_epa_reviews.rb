class CreateEpaReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :epa_reviews do |t|
      t.string    :epa
      t.datetime  :review_date1
      t.string    :reviewer1
      t.string    :badge_decision1
      t.string    :trust1
      t.text      :evidence1
      t.text      :general_comments1
      t.datetime  :review_date2
      t.string    :reviewer2
      t.string    :badge_decision2
      t.string    :trust2
      t.text      :evidence2
      t.text      :general_comments2
      t.references :reviewable, polymorphic: true, index: true
      t.timestamps
    end
    add_index :epa_reviews, [:epa, :id], :unique => true, :name => 'by_epa_reviews'
  end
end
