class RearrangeCourseSchedulesColumns2 < ActiveRecord::Migration[7.2]
  def change
    add_column :course_schedules, :tmp_created_at, :timestamp
    add_column :course_schedules, :tmp_updated_at, :timestamp
    CourseSchedule.all.each do |schedule|
      schedule.update(tmp_created_at: schedule.created_at,
      tmp_updated_at: schedule.updated_at)
    end
    remove_column :course_schedules, :course_schedule
    remove_column :course_schedules, :created_at
    remove_column :course_schedules, :updated_at

    rename_column :course_schedules, :tmp_created_at, :created_at
    rename_column :course_schedules, :tmp_updated_at, :updated_at        
  end
end
