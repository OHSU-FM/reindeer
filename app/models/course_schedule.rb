class CourseSchedule < ApplicationRecord
  belongs_to :course, optional: true
end
