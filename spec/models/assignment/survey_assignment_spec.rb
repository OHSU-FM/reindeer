require 'spec_helper'

describe "SurveyAssignment" do

  it "requires a lime_survey" do
    expect(build :survey_assignment, lime_survey: nil).not_to be_valid
  end

  it "defaults to lime_survey.title if no title is provided" do
    expect((create :survey_assignment, title: nil).title).to eq "New"
  end

  describe "methods" do
    describe "#do_gather_user_tokens" do
      it "generates user_assignments for users in sa.assignment_group" do
        ag = create :assignment_group, :with_full_template, :with_users
        u = ag.users.first
        u.email = "test@example.com"; u.save!
        sa = create :survey_assignment, assignment_group: ag
        sa.gather_user_tokens = "1"

        expect{sa.save!}.to change(u.user_assignments, :count).by(1)
      end

      it "doesn't generate uas for users not in sa.assignment_group" do
        u = create :user
        sa = create :survey_assignment
        sa.gather_user_tokens = "1"

        expect{sa.save!}.not_to change(Assignment::UserAssignment, :count)
        expect{sa.save!}.not_to change(u.user_assignments, :count)
      end
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
