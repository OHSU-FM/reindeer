require "spec_helper"

describe Assignment::AssignmentGroup do

  it "has a valid factory" do
    expect(create :assignment_group).to be_valid
  end

  it "requires an owner" do
    expect(build :assignment_group, owner: nil).not_to be_valid
    expect((create :assignment_group).owner).to be_instance_of(User)
  end

  it "requires an assignment_group_template" do
    expect(build :assignment_group, assignment_group_template: nil).not_to be_valid
  end

  it "has a list of user_ids corresponding to Users" do
    ag = create :assignment_group, :with_users

    expect(ag.user_ids).to be_instance_of(Array)
    ag.user_ids.each do |uid|
      expect(uid).to be_instance_of(String)
      expect(User.find(uid)).to be_valid
    end
  end
end
