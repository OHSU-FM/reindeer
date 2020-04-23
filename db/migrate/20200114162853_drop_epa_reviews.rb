class DropEpaReviews < ActiveRecord::Migration[5.2]
  def change
    	drop_table :epa_reviews
  end
end
