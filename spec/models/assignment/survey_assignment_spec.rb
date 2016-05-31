require 'spec_helper'

describe "SurveyAssignment" do

  it "requires a lime_survey" do
    expect(build :survey_assignment, lime_survey: nil).not_to be_valid
  end

  it "defaults to lime_survey.title if no title is provided" do
    expect((create :survey_assignment, title: nil).title).to eq "New"
  end
end
