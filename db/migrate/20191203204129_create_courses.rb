class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :competency_code
      t.string :course_no
      t.string :course_name
      t.string :department
      t.text   :course_purpose_statement
      t.timestamps
    end
    add_index :courses, [:competency_code, :course_no], unique: true
  end
end
