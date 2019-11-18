class CreateUsmleExams < ActiveRecord::Migration[5.2]
  def change
    create_table :usmle_exams do |t|
      t.references :user, index: true, foreign_key: true
      t.string :exam_type
      t.integer :no_attempts
      t.string :pass_fail
      t.integer :exam_score
      t.datetime :exam_date
      t.timestamps
    end
  end
end
