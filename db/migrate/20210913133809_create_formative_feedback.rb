class CreateFormativeFeedback < ActiveRecord::Migration[6.1]
  def change
    create_table :formative_feedbacks do |t|
      t.references :user, foreign_key: true
      t.string :block_code
      t.string :csa_code
      t.string :response_id
      t.date :submit_date
      t.string :q1
      t.string :q2
      t.string :q3
      t.string :q4
      t.string :q5
      t.string :q6
      t.string :q7
      t.string :q8
      t.timestamps
    end
    add_index :formative_feedbacks, :response_id
  end
end
