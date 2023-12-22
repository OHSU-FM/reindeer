class CreateCourseSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :course_schedules do |t|
      t.references :course, foreign_key: true
      t.string :course_schedule
      t.date :start_date
      t.date :end_date
      t.integer :no_of_seats
      t.string :comment

      t.timestamps
    end
  end
end
