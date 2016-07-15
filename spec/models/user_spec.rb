require 'spec_helper'

describe User do

  it 'has a factory' do
    expect(build :user).to be_valid
  end

  it 'requires an email' do
    user = build :user, email: nil
    expect(user).not_to be_valid
  end

  it 'requires a username' do
    user = build :user, username: nil
    expect(user).not_to be_valid
  end

  it 'requires a password' do
    user = build :user, password: nil
    expect(user).not_to be_valid
  end

  it 'has roles' do
    user = build :user
    expect(user.admin?).to be false
    user.roles = [:admin]
    expect(user.admin?).to be true
  end

  describe 'superadmin' do
    it "is admin or higher" do
      expect(build(:superadmin).admin_or_higher?).to be true
    end
  end

  describe "methods:" do
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
  end

end
