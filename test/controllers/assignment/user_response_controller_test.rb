require "test_helper"

describe Assignment::UserResponseController do
  it "should get show" do
    get :show
    value(response).must_be :success?
  end

end
