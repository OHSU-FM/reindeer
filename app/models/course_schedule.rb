class CourseSchedule < ApplicationRecord
  validates :course_id, :year, :block, :start_date, :end_date, :no_of_seats, presence: true
  belongs_to :course, optional: false  # want the activerecord to enforce the association integrity
end
