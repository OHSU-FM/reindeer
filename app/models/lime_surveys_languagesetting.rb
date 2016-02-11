class LimeSurveysLanguagesetting < ActiveRecord::Base
    self.inheritance_column = nil
    self.primary_key = :surveyls_survey_id

    belongs_to :lime_survey, :foreign_key=>:suveyls_survey_id, :primary_key=>:sid
    rails_admin do
        navigation_label "Lime Survey"
    end


end
