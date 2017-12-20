require "spec_helper"

describe Assignment::UserAssignmentsController do

  describe "get #show" do
    context "when user is logged in" do
      before do
        user = create :user
        @ua = create :user_assignment, :with_user_responses, user: user
        sign_in user
        get :show, params: { id: @ua.id }
      end

      it { is_expected.to redirect_to \
      assignment_user_response_path(@ua.user_responses.first) }
      it "assigns to @user_assignment" do
        expect(assigns[:user_assignment]).to eq @ua
      end
    end

    context "when not signed in" do
      before do
        user = create :user
        @ua = create :user_assignment, :with_user_responses, user: user
        get :show, params: { id: @ua.id }
      end

      it { is_expected.to redirect_to new_user_session_path }
      it "doesn't expose assignmets" do
        expect(assigns[:user_assignment]).to eq nil
      end
    end
  end

  describe "get #fetch_compare" do
    before do
      user = create :superadmin
      @ua = create :user_assignment, :with_user_responses, user: user
      @date = @ua.user_responses.first.submitdate
      sign_in user
      get :fetch_compare, params: { user_assignment_id: @ua.id, date: @date }, xhr: true
    end

    it "sets @ua" do
      expect(assigns[:ua]).to eq @ua
    end

    it "sets @date" do
      expect(assigns[:date]).to eq @date
    end
  end
end
