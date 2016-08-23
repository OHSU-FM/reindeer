require 'spec_helper'

describe "SurveyAssignment" do

  it "requires a lime_survey" do
    expect(build :survey_assignment, lime_survey: nil).not_to be_valid
  end

  it "defaults to lime_survey.title if no title is provided" do
    expect((create :survey_assignment, title: nil).title).to eq "New"
  end

  describe "methods" do
    it "#do_gather_user_tokens" do
      u = create :user, email: "test@example.com"
      sa = create :survey_assignment
      sa.gather_user_tokens = "1"
      sa.save!

      expect(sa.user_assignments.count).to eq 1
      expect(sa.user_assignments.first.user).to eq u
    end

    it "#survey_data_sid_and_gid" do
      sa = create :survey_assignment
      lsid = sa.lime_survey.sid; gid = sa.lime_survey.lime_groups.first.gid
      expect(sa.survey_data_sid_and_gid).to eq [lsid, gid]
    end

    it "#survey_data_questions_key" do
      sa = create :survey_assignment
      lsid, gid = sa.survey_data_sid_and_gid

      sa.survey_data_questions_key.each do |key, val|
        sid, gid, qid = key.split("X")
        expect(
          LimeQuestion.find_by(sid: sid, gid: gid, qid: qid).title
        ).to eq val
      end
    end
  end
end
