require 'rails_helper'


describe LimeSurvey do

  before do
    create_min_survey 174976
  end

  it 'should delete role_aggregates when the related lime_survey is deleted' do
    ra = RoleAggregate.new(lime_survey_sid: 174976)
    ra.save!
    RoleAggregate.where(lime_survey_sid: 174976).count.must_equal 1
    LimeSurvey.find(174976).destroy
    RoleAggregate.where(lime_survey_sid: 174976).count.must_equal 0
  end
  
  it 'should delete survey_assignments when the related lime_survey is deleted' do
    SurveyAssignment.where(lime_survey_sid: 174976).count.must_equal 0
    sa = SurveyAssignment.new(lime_survey_sid: 174976)
    sa.save!
    SurveyAssignment.where(lime_survey_sid: 174976).count.must_equal 1
    LimeSurvey.find(174976).destroy
    SurveyAssignment.where(lime_survey_sid: 174976).count.must_equal 0
  end
end

