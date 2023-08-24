class AddCourseEndDateToFomExams < ActiveRecord::Migration[7.0]
  def change
    add_column :fom_exams, :course_end_date, :date
  end
end
