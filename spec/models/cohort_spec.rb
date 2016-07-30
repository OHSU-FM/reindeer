require "spec_helper"

describe Cohort do

  it "must have a factory" do
    expect(build :cohort).to be_valid
  end

  it "requires a permission_group" do
    expect(build :cohort, permission_group: nil).to be_invalid
  end

  it "belongs to a user" do
    expect{create :cohort, owner: nil}.to raise_error(NoMethodError)
    expect((build :cohort).owner).to be_instance_of(User)
  end

  it "has a list of user_ids corresponding to Users" do
    c = build :cohort, :with_users

    expect(c.user_ids).to be_instance_of(Array)
    c.user_ids.each do |uid|
      expect(uid).to be_instance_of(String)
      expect(User.find(uid)).to exist
    end
  end

  describe "methods:" do
    it "#users should return list of users" do
      c = build :cohort, :with_users

      c.users.each do |u|
        expect(u).to be_instance_of(User)
      end
    end

    it "#assignment_groups should return list of assignment_groups" do
      c = build :cohort
      ag = create :assignment_group, cohort: c

      expect(c.assignment_groups).to eq [ag]
    end

    it "#possible_users returns list of pg users" do
      pg = build :permission_group, :with_users
      c = build :cohort, permission_group: pg

      expect(c.possible_users).to eq pg.users
    end

    it "#user_ids_enum returns a list of user title/id pairs" do
      pg = build :permission_group
      c = build :cohort, permission_group: pg
      u = build :user, permission_group: pg, cohort: c
      pg.users << u

      expect(c.user_ids_enum).to eq [[u.title, u.id]]
    end
  end
end
