require 'rails_helper'

RSpec.describe "EpaMasters", type: :request do
  describe "GET /epa_masters" do
    it "works! (now write some real specs)" do
      get epa_masters_path
      expect(response).to have_http_status(200)
    end
  end
end
