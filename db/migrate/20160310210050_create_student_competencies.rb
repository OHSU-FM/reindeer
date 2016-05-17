class CreateStudentCompetencies < ActiveRecord::Migration
  def change
    create_table :student_competencies do |t|
      t.string :student_name
      t.integer :mk1
      t.integer :mk2
      t.integer :mk3
      t.integer :mk4
      t.integer :mk5

      t.timestamps null: false
    end
  end
end
