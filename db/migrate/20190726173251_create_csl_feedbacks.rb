class CreateCslFeedbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :csl_feedbacks do |t|
      t.references :user, index: true, foreign_key: true
      t.string :csl_title
      t.date :submit_date
      t.string :cohorts
      t.string :instructor
      t.string :selected_student
      t.string :c1
      t.string :c1_feedback
      t.string :c2
      t.string :c2_feedback
      t.text :feedback_strength
      t.text :feedback_improve
      t.timestamps
    end
  end
end
