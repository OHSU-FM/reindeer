require 'rails_helper'

describe LsReportsController do

  it "should require authentication" do
    get :index
    assert_response :redirect
  end

end

