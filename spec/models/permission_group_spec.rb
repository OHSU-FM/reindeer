require "rails_helper"

describe PermissionGroup do

  it "requires a title" do
    expect(build :permission_group, title: nil)
    .not_to be_valid
  end
end
