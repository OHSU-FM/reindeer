class RemoveDenyFromEpaReviews < ActiveRecord::Migration[5.2]
  def up
    remove_column :epa_reviews, :review_date2
    remove_column :epa_reviews, :reviewed_by2
    remove_column :epa_reviews, :badge
    remove_column :epa_reviews, :insufficient_evidence
    remove_column :epa_reviews, :deny
    remove_index :epa_reviews,  name: 'by_epa_reviews_response_id'
    remove_column :epa_reviews, :response_id
  end

  def down
    add_column :epa_reviews, :review_date2, :datetime
    add_column :epa_reviews, :reviewed_by2, :string
    add_column :epa_reviews, :badge, :string
    add_column :epa_reviews, :insufficient_evidence, :string
    add_column :epa_reviews, :deny, :string
    add_column :epa_reviews, :response_id, :string
    add_index :epa_reviews, [:response_id], :unique => true, :name => 'by_epa_reviews_response_id'
  end
end
