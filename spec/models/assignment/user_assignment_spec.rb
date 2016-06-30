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

    it "builds user_resposnes" do
      ua = create :user_assignment
      ua.user_responses
    end
  end
end
