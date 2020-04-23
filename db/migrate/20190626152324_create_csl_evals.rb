class CreateCslEvals < ActiveRecord::Migration[5.2]
  def change
    create_table :csl_evals do |t|
      t.references :user, index: true, foreign_key: true
      t.string :csl_title
      t.date    :submit_date
      t.string :cohorts
      t.string :instructor
      t.string :selected_student
      t.integer :c1
      t.integer :c2
      t.integer :c3
      t.integer :c4
      t.integer :c5
      t.integer :c6
      t.integer :c7
      t.integer :c8
      t.integer :c9
      t.text    :feedback
      t.timestamps
    end
  end
end
