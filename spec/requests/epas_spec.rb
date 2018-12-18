require 'rails_helper'

RSpec.describe "Epas", type: :request do
  describe "GET /epas" do
    it "works! (now write some real specs)" do
      get epas_path
      expect(response).to have_http_status(200)
    end
  end
end
