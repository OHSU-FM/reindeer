require "spec_helper"

describe Assignment::UserResponse do

  it "has a factory" do
    expect(FactoryBot.create(:user_response)).to be_valid
  end

  it "requires a user_assignment" do
    expect(build :user_response, user_assignment_id: nil).not_to be_valid
  end

  it "should validate content" do
    expect(build :user_response, content: nil).not_to be_valid
  end

  describe "methods" do
    it "#assignment_group via user_assign & survey_assign" do
      expect((build :user_response).assignment_group)
      .to be_instance_of Assignment::AssignmentGroup
    end

    it "#has_comments?" do
      expect((create :user_response, :with_comments).has_comments?).to be true
      expect((create :user_response).has_comments?).to be false
    end

    it "#has_user_comments?" do
      expect((create :user_response, :with_comments).has_user_comments?).to be true
      expect((create :user_response, :with_sys_comment).has_user_comments?).to be false
    end
  end
end
