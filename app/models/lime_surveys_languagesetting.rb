class LimeSurveysLanguagesetting < ActiveRecord::Base
  self.inheritance_column = nil
  self.primary_key = :surveyls_survey_id

  belongs_to :lime_survey, foreign_key: :surveyls_survey_id, primary_key: :sid

  has_many :lime_groups, -> { order "lime_groups.group_order" },
    foreign_key: :sid


  rails_admin do
    navigation_label "Lime Survey"
  end

end
