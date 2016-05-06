require "rails_helper"

describe Assignment::UserResponsesController do
  it "should get show" do
    get :show
    value(response).must_be :success?
  end

end
