class CreateEpaReviews < ActiveRecord::Migration[5.2]
  def up
    create_table :epa_reviews do |t|
      t.string    :epa
      t.datetime  :review_date1
      t.string    :reviewed_by1
      t.string    :egm_recommendation1
      t.string    :badge1
      t.string    :insufficient_evidence1
      t.string    :deny1
      t.text      :general_comments1
      t.datetime  :review_date2
      t.string    :reviewed_by2
      t.string    :egm_recommendation2
      t.string    :badge2
      t.string    :insufficient_evidence2
      t.string    :deny2
      t.text      :general_comments2
      t.references :reviewable, polymorphic: true, index: true
      t.timestamps
    end

    def downn
      drop_table :epa_reviews
    end

    add_index :epa_reviews, [:epa, :id], :unique => true, :name => 'by_epa_reviews'


  end
end
