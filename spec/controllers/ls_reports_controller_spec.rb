require "spec_helper"

describe LsReportsController do

  it "should require authentication" do
    get :index
    assert_response :redirect
  end

  it "should set @survey_groups" do
    ra = create :role_aggregate, :ready
    l = ra.lime_survey
    u = create :admin

    sign_in u
    get :index
    expect(assigns["survey_groups"].lime_surveys).to include l
  end

  it "should set @cohorts" do
    a = create :admin
    c = create :cohort, owner: a

    sign_in a
    get :index
    expect(assigns["cohorts"]).to include c
  end

  it "should set @role_aggregates" do
    l = create :lime_survey, role_aggregate: (create :role_aggregate, :ready)
    u = create :admin

    sign_in u
    get :index
    expect(assigns["survey_groups"].role_aggregates).to include l.role_aggregate
  end

  it "should allow a filter by group title" do
    ra = create :role_aggregate, :ready
    l = ra.lime_survey
    lsls = create :lime_surveys_languagesetting, lime_survey: l, surveyls_title: "test:survey"
    l.save!
    l2 = create :lime_survey, role_aggregate: (create :role_aggregate, :ready)
    u = create :admin

    sign_in u
    get :index, group_filter: "test"
    expect(assigns["survey_groups"].first.group_title).to eq "test"
    expect(assigns["survey_groups"].first.surveys).to include l
    expect(assigns["survey_groups"].first.surveys).not_to include l2
  end
end
