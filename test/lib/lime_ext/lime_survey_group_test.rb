require "test_helper"
require "lime_ext/lime_survey_group"

class LimeExt::LimeSurveyGroupTest < ActiveSupport::TestCase
  let(:l_s) { lime_surveys(:test_lime_survey) }

  test "initialize" do
    lsg = LimeExt::LimeSurveyGroup.classify([l_s])

    assert_equal lsg.first.lime_surveys, [ l_s ]
    assert_equal lsg.first.group_title, "test"
  end

  test "should split lime_surveys up by group" do
    l_s2 = l_s.dup # l_s2 has no lime_surveys_languagesettings => no group_title
    l_s2.sid = 54321
    lsg = LimeExt::LimeSurveyGroup.classify([l_s, l_s2])

    assert_equal lsg.first.lime_surveys, [ l_s ]
    assert_equal lsg.second.lime_surveys, [ l_s2 ]
    assert_equal lsg.first.group_title, "test"
    assert_equal lsg.second.group_title, ""
  end

  test "should filter by group if present" do
    l_s2 = l_s.dup # l_s2 has no lime_surveys_languagesettings => no group_title
    l_s2.sid = 54321
    opts = { filter: "test" }
    lsg = LimeExt::LimeSurveyGroup.classify([l_s2, l_s], opts)

    assert_equal lsg.first.lime_surveys, [ l_s ]
  end
end
