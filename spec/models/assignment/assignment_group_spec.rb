require "spec_helper"

describe Assignment::AssignmentGroup do

  it "has a valid factory" do
    expect(create :assignment_group).to be_valid
  end

  it "requires a cohort" do
    expect(build :assignment_group, cohort: nil).not_to be_valid
  end

  it "requires an assignment_group_template" do
    expect(build :assignment_group, assignment_group_template: nil).not_to be_valid
  end

  it "sets some defaults" do
    agt = build :assignment_group_template, :with_surveys
    ag = build :assignment_group, assignment_group_template: agt,
      title: nil,
      desc_md: nil,
      status: nil
    ag.save!

    expect(ag.title).to eq agt.title
    expect(ag.desc_md).to eq agt.desc_md
    expect(ag.status).to eq 1
  end

  describe ".cohort attributes" do
    it "has an owner" do
      expect((build :assignment_group).owner).to be_instance_of(User)
    end

    it "has a list of possible_users" do
      cohort = build :cohort, :with_users
      ag = build :assignment_group, cohort: cohort

      expect(ag.possible_users).to eq cohort.possible_users
    end

    it "can have a list of users" do
      ag = build :assignment_group, :with_users

      ag.users.each do |u|
        expect(u).to be_instance_of(User)
      end
    end

    it "can have a list of user_ids corresponding to Users" do
      ag = build :assignment_group, :with_users

      expect(ag.user_ids).to be_instance_of(Array)
      ag.user_ids.each do |uid|
        expect(uid).to be_instance_of(String)
        expect(User.find(uid)).to be_valid
      end
    end
  end

  describe "methods" do

    it "#user_assignments_for returns user_assignments filtered by uid" do
      ua = create :user_assignment
      user = ua.user; ag = ua.assignment_group

      expect(ag.user_assignments_for user.id).to eq [ua]
    end
  end
end
