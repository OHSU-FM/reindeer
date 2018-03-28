require "spec_helper"

describe LimeExt::LimeSurveyGroup do
  let(:lime_survey) { create :lime_survey, :with_languagesettings }

  it "initialize" do
    lsg = LimeExt::LimeSurveyGroup.classify([lime_survey])

    expect(lsg.first.lime_surveys).to eq [ lime_survey ]
    expect(lsg.first.group_title).to eq "test_group"
  end

  it "should split lime_surveys up by group" do
    lime_survey2 = lime_survey.dup
    # lime_survey2 has no lime_surveys_languagesettings => no group_title
    lime_survey2.sid = 54321
    lsg = LimeExt::LimeSurveyGroup.classify([lime_survey, lime_survey2])

    expect(lsg.first.lime_surveys).to eq [ lime_survey ]
    expect(lsg.second.lime_surveys).to eq [ lime_survey2 ]
    expect(lsg.first.group_title).to eq "test_group"
    expect(lsg.second.group_title).to eq ""
  end

  it "should filter by group if present" do
    lime_survey2 = lime_survey.dup
    # lime_survey2 has no lime_surveys_languagesettings => no group_title
    lime_survey2.sid = 54321
    opts = { group_filter: "test_group" }
    lsg = LimeExt::LimeSurveyGroup.classify([lime_survey, lime_survey2], opts)

    expect(lsg.first.lime_surveys).to eq [ lime_survey ]
  end
end
