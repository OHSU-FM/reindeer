class RearrangeCourseSchedulesColumns < ActiveRecord::Migration[7.2]
  def change
    add_column :course_schedules, :year, :integer
    add_column :course_schedules, :block, :string
    add_column :course_schedules, :tmp_start_date, :date
    add_column :course_schedules, :tmp_end_date, :date
    add_column :course_schedules, :tmp_no_of_seats, :integer
    add_column :course_schedules, :tmp_comment, :string

    CourseSchedule.all.each do |schedule|
      yr, bk = schedule.course_schedule.split(" ", 2)
      schedule.update(year: yr, block: bk, tmp_start_date: schedule.start_date,
      tmp_end_date: schedule.end_date, tmp_no_of_seats: schedule.no_of_seats,
      tmp_comment: schedule.comment)
    end
    #remove original columns
    remove_column :course_schedules, :start_date
    remove_column :course_schedules, :end_date
    remove_column :course_schedules, :no_of_seats
    remove_column :course_schedules, :comment

    #rename new columns
    rename_column :course_schedules, :tmp_start_date, :start_date
    rename_column :course_schedules, :tmp_end_date, :end_date
    rename_column :course_schedules, :tmp_no_of_seats, :no_of_seats
    rename_column :course_schedules, :tmp_comment, :comment

  end
end


# t.references :course, foreign_key: true
# t.string :course_schedule
# t.date :start_date
# t.date :end_date
# t.integer :no_of_seats
# t.string :comment
