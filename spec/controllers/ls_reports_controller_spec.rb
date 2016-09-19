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
    lsls = create :lime_surveys_languagesetting, surveyls_title: "test:survey"
    l = create :lime_survey_full; l.lime_surveys_languagesettings << lsls; l.save!
    ra = create :role_aggregate, :ready, lime_survey: l
    l2 = create :lime_survey, role_aggregate: (create :role_aggregate, :ready)
    u = create :admin

    sign_in u
    get :index, group_filter: "test"
    expect(assigns["survey_groups"].first.group_title).to eq "test"
    expect(assigns["survey_groups"].first.surveys).to eq [ l ]
  end
end
