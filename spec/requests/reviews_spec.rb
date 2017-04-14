require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  describe "GET /reviews" do
    context "without a valid session" do
      it "redirects to login" do
        get reviews_path
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "with valid session" do
      before(:each) { @u = create :user; sign_in(@u) }

      it "is successful" do
        get reviews_path
        expect(response).to have_http_status(200)
      end
    end
  end
end
