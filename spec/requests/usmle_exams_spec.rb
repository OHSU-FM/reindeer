require 'rails_helper'

RSpec.describe "UsmleExams", type: :request do
  describe "GET /usmle_exams" do
    it "works! (now write some real specs)" do
      get usmle_exams_path
      expect(response).to have_http_status(200)
    end
  end
end
