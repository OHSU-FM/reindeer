require 'test_helper'

describe User do
  def setup
    create_min_survey
    create_min_response
  end

  it 'has a factory' do
    create :user
    assert_equal User.count, 1
  end

  it 'requires an email' do
    user = build :user, email: nil
    refute user.save
  end

  it 'requires a username' do
    user = build :user, username: nil
    refute user.save
  end

  it 'requires a password' do
    user = build :user, password: nil
    refute user.save
  end

  it 'has roles' do
    user = build :user
    refute user.admin?
    user.roles = [:admin]
    assert user.admin?
  end

  it 'can list assignment_groups it owns' do
    user = create(:user)
    create(:assignment_group, :with_template, owner: user)
    assert_equal 1, user.assignment_groups.count
  end

  describe 'superadmin' do
    it "is admin or higher" do
      user = build(:superadmin)
      assert_equal true, user.admin_or_higher?
    end
  end

end
