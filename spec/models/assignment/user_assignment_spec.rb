require 'spec_helper'

describe Assignment::UserAssignment do

  it "has a factory" do
    expect(create :user_assignment).to be_valid
  end

  it "requires a user" do
    expect(build :user_assignment, user: nil).not_to be_valid
  end

  it "requires a lime_survey" do
    expect(build :user_assignment, lime_survey: nil).not_to be_valid
  end

  it "has user_responses" do
    ua = build :user_assignment, :with_user_responses

    ua.user_responses.each do |ur|
      expect(ur).to be_instance_of(Assignment::UserResponse)
    end
  end

  describe "methods" do
    it "#response_data" do
      ua = create :user_assignment
      l_s = ua.lime_survey
      data = ua.response_data

      expect(data).to be_instance_of Hash
      expect(l_s.lime_tokens.dataset.first["token"]).to eq data["token"]
      ua.lime_questions.each do |lq|
        expect(data).to have_key "#{lq.sid}X#{lq.gid}X#{lq.qid}"
      end
    end

    it "has a status string" do
      ua = build :user_assignment

      expect(ua.status_str).to eq "complete"
    end

    it "has an assignment_group via survey_assignment" do
      ua = build :user_assignment

      expect(ua.assignment_group).to be_instance_of(Assignment::AssignmentGroup)
    end

    it "has a group_and_title_name via survey_assignment & lime_survey" do
      ua = build :user_assignment

      expect(ua.group_and_title).to be_instance_of(Array)
    end

    it "has a list of lime_question objects" do
      ua = create :user_assignment

      expect(ua.lime_questions).to be_instance_of Array
      ua.lime_questions.each do |obj|
        expect(obj).to be_instance_of LimeQuestion
      end
    end

    it "test" do
      ua = create :user_assignment
      ua.gathered_responses_2
    end
  end
end
