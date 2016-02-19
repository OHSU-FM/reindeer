require 'test_helper'
require 'factories/lime_survey'

class LsReportsControllerTest < ActionController::TestCase
  def setup
    create_min_survey
    create_min_response
    FactoryGirl.create(:coach_permission_group)
    FactoryGirl.create(:role_aggregate)
    FactoryGirl.create(:pls_group)
  end
  let(:lime_survey) { LimeSurvey.find(12345) }
  let(:pg) { PermissionGroup.first }
  let(:plsg) { PermissionLsGroup.first }
  let(:coach) { FactoryGirl.create(:coach) }
  let(:user) { FactoryGirl.create(:user) }

  let(:lime_question) { lime_questions(:lime_question) }
  let(:lime_group) { lime_groups(:lime_group) }

  test "index should require authentication" do
    get :index
    assert_response :redirect

    sign_in coach
    get :index
    assert_response :success
  end

  test "index should list surveys we are allowed to see" do
    sign_in coach
    get :index
    assert_equal assigns[:survey_groups].lime_surveys, [ lime_survey ]
  end

end

