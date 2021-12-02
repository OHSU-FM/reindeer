class CreateFomRemeds < ActiveRecord::Migration[6.1]
  def change
    create_table :fom_remeds do |t|
      t.integer :user_id, index: true, foreign_key: true
      t.string :block
      t.string :component_failed
      t.string :component_desc
      t.decimal :initial_test_result
      t.string :areas_of_deficiency
      t.decimal :re_test_result
      t.string :passed_failed
      t.integer :prev_comp_failures
      t.integer :no_of_failures_to_date
      t.string :acad_probation
      t.string :notes
      t.timestamps
    end
  end
end
