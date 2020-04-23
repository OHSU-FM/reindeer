require 'rails_helper'

RSpec.describe "EpaReviews", type: :request do
  describe "GET /epa_reviews" do
    it "works! (now write some real specs)" do
      get epa_reviews_path
      expect(response).to have_http_status(200)
    end
  end
end
