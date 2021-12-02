class AddReason1ToChangeEpaReviewsTable < ActiveRecord::Migration[5.2]
  def change
    add_column :epa_reviews, :reason1, :string
    add_column :epa_reviews, :reason2, :string
    add_column :epa_reviews, :student_comments1, :string
    add_column :epa_reviews, :student_comments2, :string
  end

end
