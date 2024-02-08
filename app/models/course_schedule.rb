class CourseSchedule < ApplicationRecord
  belongs_to :course, optional: false  # want the activerecord to enforce the association integrity
end
