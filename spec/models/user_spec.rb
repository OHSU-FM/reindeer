require 'spec_helper'

describe User do

  it 'has a factory' do
    user = create :user
    expect(user).to be_valid
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

  describe "assignment framework interactions" do
    it 'can list assignment_groups it owns' do
      user = create(:user)
      create(:assignment_group, cohort: create(:cohort, owner: user))
      expect(user.assignment_groups.count).to eq 1
    end
  end

end
