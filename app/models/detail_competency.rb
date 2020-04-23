class DetailCompetency < ApplicationRecord
  self.table_name = "lime_survey_917581"
  belongs_to :Competency, foreign_key: :student_uid

end
