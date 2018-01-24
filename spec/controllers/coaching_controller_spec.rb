require 'rails_helper'

RSpec.describe CoachingController, type: :controller do
  let(:coach) { create :user, coaching_type: 'coach' }
  let(:student) { create :user, coaching_type: 'student' }
  let!(:cohort) { create :cohort, owner: coach, users: [student] }

  describe "GET #index" do
    context "when student is logged in" do
      before(:each) do
        login_user student
      end

      it "redirects to coaching::students#show w current_user" do
        get :index
        expect(response).to redirect_to "/coaching/students/#{student.email}"
      end
    end

    context "when coach is logged in" do
      before(:each) do
        login_user coach
      end

      it "redirects to coaching::students#show w the first student" do
        get :index
        expect(response).to redirect_to "/coaching/students/#{student.email}"
      end
    end

    context "when dean is logged in" do
      let(:dean) { create :user, coaching_type: 'dean' }
      before(:each) do
        login_user dean
        create :goal, user: student
      end

      it "redirects to coaching::students#show w the first student" do
        get :index
        expect(response).to redirect_to "/coaching/students/#{student.email}"
      end
    end

    context "when no user is logged in" do
      it "redirects to sign in" do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
