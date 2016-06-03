require "spec_helper"

describe Cohort do

  it "must have a factory" do
    expect(create :cohort).to be_valid
  end

  it "requires a permission_group" do
    expect(build :cohort, permission_group: nil).to be_invalid
  end

  it "belongs to a user" do
    expect{create :cohort, owner: nil}.to raise_error(NoMethodError)
    expect((create :cohort).owner).to be_instance_of(User)
  end

  it "has a list of user_ids corresponding to Users" do
    c = create :cohort, :with_users

    expect(c.user_ids).to be_instance_of(Array)
    c.user_ids.each do |uid|
      expect(uid).to be_instance_of(String)
      expect(User.find(uid)).to be_valid
    end
  end

end
