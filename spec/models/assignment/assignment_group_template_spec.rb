require "spec_helper"

describe Assignment::AssignmentGroupTemplate do

  it "has a factory" do
    expect(create :assignment_group_template).to be_valid
  end

  it "requires lime_surveys" do
    expect(build :assignment_group_template, ls_count: 0).not_to be_valid
  end

  it "requires a title" do
    expect(build :assignment_group_template, title: nil).not_to be_valid
  end

  it "has an enum of active lime_surveys" do
    agt = create :assignment_group_template
    l_s = create :lime_survey, :active

    expect(agt.lime_surveys_enum).to include l_s
    expect(agt.lime_surveys_enum).not_to eq agt.lime_surveys
  end

  it "sets and gets lime_surveys" do
    l_s = build :lime_survey
    agt = build :assignment_group_template, ls_count: 0
    agt.lime_surveys = [l_s]
    agt.save!

    expect(agt).to be_valid
    expect(agt.lime_surveys).to eq [l_s]
  end

  it "has a list of sids" do
    agt = build :assignment_group_template, ls_count: 0
    l_s = build :lime_survey
    agt.lime_surveys = [l_s]
    agt.save!

    expect(agt.sids).to eq [l_s.sid]
  end

  it "has a list of ls titles and sids" do
    agt = build :assignment_group_template, ls_count: 0
    l_s = create :lime_survey, :active

    expect(agt.sids_enum).to eq [[l_s.title, l_s.sid]]
  end
end
