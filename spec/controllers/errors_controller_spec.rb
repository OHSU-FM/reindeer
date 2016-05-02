require 'rails_helper'

describe ErrorsController do
  it "should get file_not_found" do
    get :file_not_found
    assert_response 404
  end

  it "should get unprocessable" do
    get :unprocessable
    assert_response 422
  end

  it "should get internal_server_error" do
    get :internal_server_error
    assert_response 500
  end

  it "should get not_authorized" do
    get :not_authorized
    assert_response 403
  end
end
