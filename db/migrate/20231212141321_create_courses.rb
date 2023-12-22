class CreateCourses < ActiveRecord::Migration[7.1]
  def change
    drop_table(:courses, if_exists: true)

    create_table :courses do |t|
      t.string :course_number
      t.string :course_name
      t.string :content_type
      t.integer :medhub_course_id
      t.boolean :rural
      t.boolean :continuity
      t.boolean :available_through_the_lottery
      t.string :department
      t.string :course_purpose_statement
      t.string :special_notes
      t.boolean :prerequisites
      t.string :required_prerequisites
      t.boolean :waive_prereq_requirements
      t.string :waive_notes
      t.string :duration
      t.string :site
      t.integer :weekly_workload
      t.integer :credits
      t.string :course_director
      t.string :course_director_email
      t.string :course_coordinator
      t.string :course_coordinator_email
      t.text :competencies, array: true, default: []
      t.timestamps
    end
  end
end
