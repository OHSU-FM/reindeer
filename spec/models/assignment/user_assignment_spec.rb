require 'spec_helper'

describe Assignment::UserAssignment do

  it "has a factory" do
    expect(create :user_assignment).to be_valid
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

    it "#is_shallow?" do
      ua_w_1 = create :user_assignment, :with_user_responses
      ua_w_2 = create :user_assignment, :with_user_responses, ur_count: 2

      expect(ua_w_1.is_shallow?).to be true
      expect(ua_w_2.is_shallow?).to be false
    end

    describe "user_responses" do
      it "retrieves list of user_responses.where(ua: self) if they exist" do
        ua = create :user_assignment
        ur = create :user_response, user_assignment: ua

        expect(ua.user_responses).to include ur
        expect{ua.user_responses}.to change{Assignment::UserResponse.count}.by(0)
      end
    end
  end

  describe "associations" do
    it "belongs_to user" do
      ua = Assignment::UserAssignment.reflect_on_association(:user)
      expect(ua.macro).to eq :belongs_to
    end

    it "belongs_to survey_assignment" do
      saa = Assignment::UserAssignment.reflect_on_association(:survey_assignment)
      expect(saa.macro).to eq :belongs_to
    end

    it "has_one lime_survey" do
      lsa = Assignment::UserAssignment.reflect_on_association(:lime_survey)
      expect(lsa.macro).to eq :has_one
    end

    it "has_many user_responses" do
      ura = Assignment::UserAssignment.reflect_on_association(:user_responses)
      expect(ura.macro).to eq :has_many
    end

    it "has_many lime_groups" do
      lga = Assignment::UserAssignment.reflect_on_association(:lime_groups)
      expect(lga.macro).to eq :has_many
    end

    it "has_many lime_questions" do
      lqa = Assignment::UserAssignment.reflect_on_association(:lime_questions)
      expect(lqa.macro).to eq :has_many
    end

    describe "validation" do
      it "requires a user" do
        expect(build :user_assignment, user: nil).not_to be_valid
      end

      it "requires a lime_survey" do
        expect(build :user_assignment, lime_survey: nil).not_to be_valid
      end
    end
  end
end
