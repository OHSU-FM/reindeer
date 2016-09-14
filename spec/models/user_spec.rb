require "spec_helper"

describe User do

  it "has a factory" do
    expect(build :user).to be_valid
  end

  it "requires an email" do
    user = build :user, email: nil
    expect(user).not_to be_valid
  end

  it "requires a username" do
    user = build :user, username: nil
    expect(user).not_to be_valid
  end

  it "requires a password" do
    user = build :user, password: nil
    expect(user).not_to be_valid
  end

  it "has roles" do
    user = build :user
    expect(user.admin?).to be false
    user.roles = [:admin]
    expect(user.admin?).to be true
  end

  describe "superadmin" do
    it "is admin or higher" do
      expect(build(:superadmin).admin_or_higher?).to be true
    end
  end

  describe "methods:" do
    it "#lime_surveys lists lime_surveys user has access to" do
      ra = create :role_aggregate, :ready
      a = create :admin
      expect(a.lime_surveys.count).to eq 1
    end

    it "#lime_surveys_most_recent returns most recent lime_surveys" do
      a = create :admin
      s1 = create :lime_survey, :with_languagesettings, :full, opts: {"response": {"submitdate": '2016-08-08'}}
      s2 = create :lime_survey, :with_languagesettings, :full
      ra1 = create :role_aggregate, :ready, lime_survey: s1
      ra2 = create :role_aggregate, :ready, lime_survey: s2
      expect(a.lime_surveys_most_recent).to eq [s1]
      expect(a.lime_surveys_most_recent(2)).to eq [s1, s2]
    end

    it "#cohort returns cohort user belongs to" do
      c = create :cohort, :with_users
      user = c.users.first
      expect(user.cohort).to eq c
    end

    it "#cohorts returns list of cohorts user owns" do
      user = build :user
      c = create :cohort, owner: user
      c2 = create :cohort
      expect(user.cohorts).to eq [c]
      expect(user.cohorts).not_to include c2
    end

    it "#cohorts returns list of all cohorts as admin" do
      admin = build :admin
      c = create :cohort
      expect(admin.cohorts).to include c
    end

    it "#active_assignment_groups returns ags user owns that have users" do
      user = build :user
      create(:assignment_group, cohort: build(:cohort, owner: user))
      expect(user.active_assignment_groups.count).to eq 0
      user2 = build :user
      create(:assignment_group, cohort: build(:cohort, :with_users, owner: user2))
      expect(user2.active_assignment_groups.count).to eq 1
    end

    it "#assignment_groups lists ags user owns" do
      user = build :user
      create(:assignment_group, cohort: build(:cohort, owner: user))
      expect(user.assignment_groups.count).to eq 1
    end

    it "#assignment_groups lists ags user belongs to" do
      c = build :cohort, :with_users
      user = c.users.first
      create :assignment_group, cohort: c

      expect(user.assignment_groups.count).to eq 1
    end

    it "#display_name" do
      u = create :user
      u_nil = create :user, full_name: nil, username: "test"
      test_str = ["first last", "last, first", "first middle last",
                  "last, first middle", "first last-last", "last-last, first"
      ]
      key = ["first last", "first last", "first middle last",
             "first middle last", "first last-last", "first last-last"
      ]

      expect(u.display_name).to eq u.full_name
      expect(u_nil.display_name).to eq "test"
      test_str.each_with_index {|str, i|
        expect(User.new.display_name str).to eq key[i]
      }
    end

    it "#unstatused_user_responses?" do
      (1..3).to_a.each do |i|
        ua = create :user_assignment, :with_user_responses, ur_count: i, owner_status: nil
        expect(ua.user.unstatused_user_responses_count).to eq i
      end

      ua = create :user_assignment
      ur1 = create :user_response, user_assignment: ua
      ur2 = create :user_response, owner_status: nil, user_assignment: ua
      expect(ua.user.unstatused_user_responses_count).to eq 1
    end
  end

end
