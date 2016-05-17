class CreateCompentencies < ActiveRecord::Migration
  def change
    create_table :compentencies do |t|
      t.string :student_name
      t.string :evaluator
      t.string :rotation_date
      t.string :service
      t.integer :answer
      t.string :compentency_code
      t.string :block_name
      t.string :question

      t.timestamps null: false
    end
  end
end
