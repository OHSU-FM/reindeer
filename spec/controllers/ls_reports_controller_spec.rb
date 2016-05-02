require 'rails_helper'

describe LsReportsController do
  def setup
    FactoryGirl.create(:coach_permission_group)
    FactoryGirl.create(:role_aggregate)
    FactoryGirl.create(:pls_group)
  end
  let(:lime_survey) { create :lime_survey, :with_tables, :with_response }
  let(:pg) { PermissionGroup.first }
  let(:plsg) { PermissionLsGroup.first }
  let(:coach) { FactoryGirl.create(:coach) }
  let(:user) { FactoryGirl.create(:user) }

  let(:lime_question) { lime_questions(:lime_question) }
  let(:lime_group) { lime_groups(:lime_group) }

  it "index should require authentication" do
    get :index
    assert_response :redirect

    login :coach
    get :index
    assert_response :success
  end

  it "index should list surveys we are allowed to see" do
    sign_in coach
    get :index
    assert_equal assigns[:survey_groups].lime_surveys, [ lime_survey ]
  end

end

