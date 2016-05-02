require "rails_helper"

describe Assignment::UserResponse do
  let(:user_response) { Assignment::UserResponse.new }

  it "must be valid" do
    value(user_response).must_be :valid?
  end
end
