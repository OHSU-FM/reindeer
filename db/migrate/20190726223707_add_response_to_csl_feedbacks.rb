class AddResponseToCslFeedbacks < ActiveRecord::Migration[5.2]
  def change
    add_column :csl_feedbacks, :response_id, :string
    add_index :csl_feedbacks, :response_id, unique: true
  end
end
