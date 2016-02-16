require "test_helper"
require "lime_ext/lime_survey_group"
require "factories/lime_survey"

class LimeExt::LimeSurveyGroupTest < ActiveSupport::TestCase
  def setup
    create_min_survey
    create_min_response
  end
  let(:lime_survey) { LimeSurvey.find(12345) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:p_g) { FactoryGirl.create(:high_permission_group) }
  let(:ra) { FactoryGirl.create(:role_aggregate, lime_survey: lime_survey) }
  let(:p_ls_g) { FactoryGirl.create(:p_ls_g_one, lime_survey: lime_survey, permission_group: p_g) }

  test "initialize" do
    lsg = LimeExt::LimeSurveyGroup.classify([lime_survey])

    assert_equal lsg.first.lime_surveys, [ lime_survey ]
    assert_equal lsg.first.group_title, "test"
  end

  test "should split lime_surveys up by group" do
    lime_survey2 = lime_survey.dup
    # lime_survey2 has no lime_surveys_languagesettings => no group_title
    lime_survey2.sid = 54321
    lsg = LimeExt::LimeSurveyGroup.classify([lime_survey, lime_survey2])

    assert_equal lsg.first.lime_surveys, [ lime_survey ]
    assert_equal lsg.second.lime_surveys, [ lime_survey2 ]
    assert_equal lsg.first.group_title, "test"
    assert_equal lsg.second.group_title, ""
  end

  test "should filter by group if present" do
    lime_survey2 = lime_survey.dup
    # lime_survey2 has no lime_surveys_languagesettings => no group_title
    lime_survey2.sid = 54321
    opts = { filter: "test" }
    lsg = LimeExt::LimeSurveyGroup.classify([lime_survey, lime_survey2], opts)

    assert_equal lsg.first.lime_surveys, [ lime_survey ]
  end
end
