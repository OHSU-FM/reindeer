class CreateFomExams < ActiveRecord::Migration[5.2]
  def change
    create_table :fom_exams do |t|
      t.string :course_code
      t.datetime :submit_date
      t.decimal :wk1
      t.decimal :wk2
      t.decimal :wk3
      t.decimal :wk4
      t.decimal :wk5
      t.decimal :wk6
      t.decimal :wk7
      t.decimal :wk8
      t.decimal :wk9
      t.decimal :wk10
      t.decimal :dropped_score
      t.string  :dropped_quiz
      t.references :user, foreign_key: true
      t.timestamps
    end
    add_index :fom_exams, [:user_id, :course_code], :unique => true, :name => 'by_user_course_code'
  end
end
