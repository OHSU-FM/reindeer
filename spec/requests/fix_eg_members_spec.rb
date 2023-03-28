require 'rails_helper'

RSpec.describe "FixEgMembers", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/fix_eg_members/index"
      expect(response).to have_http_status(:success)
    end
  end

end
