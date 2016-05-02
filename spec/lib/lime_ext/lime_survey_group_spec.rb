require "rails_helper"

describe LimeExt::LimeSurveyGroup do
  let(:lime_survey) { create :lime_survey }

  it "initialize" do
    lsg = LimeExt::LimeSurveyGroup.classify([lime_survey])

    assert_equal lsg.first.lime_surveys, [ lime_survey ]
    assert_equal lsg.first.group_title, "test"
  end

  it "should split lime_surveys up by group" do
    lime_survey2 = lime_survey.dup
    # lime_survey2 has no lime_surveys_languagesettings => no group_title
    lime_survey2.sid = 54321
    lsg = LimeExt::LimeSurveyGroup.classify([lime_survey, lime_survey2])

    assert_equal lsg.first.lime_surveys, [ lime_survey ]
    assert_equal lsg.second.lime_surveys, [ lime_survey2 ]
    assert_equal lsg.first.group_title, "test"
    assert_equal lsg.second.group_title, ""
  end

  it "should filter by group if present" do
    lime_survey2 = lime_survey.dup
    # lime_survey2 has no lime_surveys_languagesettings => no group_title
    lime_survey2.sid = 54321
    opts = { filter: "test" }
    lsg = LimeExt::LimeSurveyGroup.classify([lime_survey, lime_survey2], opts)

    assert_equal lsg.first.lime_surveys, [ lime_survey ]
  end
end
