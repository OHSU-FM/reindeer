class CreateEpas < ActiveRecord::Migration[5.2]
  def change
    create_table :epas do |t|
      t.datetime :submit_date
      t.string :student_assessed
      t.string :epa
      t.string :clinical_discipline
      t.string :clinical_setting
      t.string :clinical_assessor
      t.string :assessor_name
      t.string :no_of_times_with_super
      t.integer :involvement
      t.string :more_independent
      t.boolean :encounter_complex
      t.string :assessor_email
      t.timestamps
      t.references :user, foreign_key: true
    end
  end
end
