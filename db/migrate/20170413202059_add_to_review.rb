class AddToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :title, :string
    add_column :reviews, :clinical_fte, :float
    add_column :reviews, :research_fte, :float
    add_column :reviews, :research_grant_fte, :float
    add_column :reviews, :research_dept_fte, :float
    add_column :reviews, :administrative_fte, :float
    add_column :reviews, :total_fte, :float
    add_column :reviews, :hire_date, :datetime
  end
end
