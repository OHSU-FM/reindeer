class Course < ApplicationRecord
  has_many :course_schedules, dependent: :destroy
end
