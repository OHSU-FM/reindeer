class CreateEpaReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :epa_reviews do |t|
      t.string    :epa
      t.datetime  :review_date1
      t.string    :reviewed_by1
      t.datetime  :review_date2
      t.string    :reviewed_by2
      t.string    :egm_recommendation
      t.string    :badge
      t.string    :insufficient_evidence
      t.string    :deny
      t.text      :general_comments
      t.string    :response_id
      t.references :reviewable, polymorphic: true, index: true
      t.timestamps
    end
    add_index :epa_reviews, [:epa, :id], :unique => true, :name => 'by_epa_reviews'
    add_index :epa_reviews, [:response_id], :unique => true, :name => 'by_epa_reviews_response_id'
  end
end
