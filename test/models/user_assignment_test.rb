require 'test_helper'

class UserAssignmentTest < ActiveSupport::TestCase
  it "has a valid factory" do
    assert false
  end

  it "can be created" do
    binding.pry
  end

  it "requires a user" do
    user = create(:user)
    binding.pry
  end

end
