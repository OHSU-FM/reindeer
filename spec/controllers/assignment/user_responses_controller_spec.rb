require "spec_helper"

describe Assignment::UserResponsesController do

  describe "get #show" do
    context "with signed in user" do
      before do
        @ua = create :user_assignment
        @ur = create :user_response, user_assignment: @ua
        sign_in @ua.user
        get :show, params: { id: @ur.id }
      end

      it { expect(response).to be_success }
      it { expect(assigns[:user_response]).to eq @ur }
      it { expect(controller.params[:user_id]).to eq @ua.user.id.to_s }
      it { expect(assigns[:assignment_group]).to eq @ua.assignment_group }
      it { expect(assigns[:assignment_groups])
           .to eq @ua.user.active_assignment_groups }
    end

    context "without signed in user" do
      before do
        @ua = build :user_assignment
        @ur = create :user_response, user_assignment: @ua
        get :show, params: { id: @ur.id }
      end

      it { is_expected.to redirect_to new_user_session_path }
      it { expect(assigns[:user_response]).to eq nil}
      it { expect(assigns[:assignment_group]).to eq nil}
      it { expect(assigns[:assignment_groups]).to eq nil}
    end
  end

  describe "get #set_owner_status" do
    context "with initially nil owner_status" do
      before do
        @ua = create :user_assignment
        @ur = create :user_response, user_assignment: @ua, owner_status: nil
        sign_in @ua.user
        get :set_owner_status, params: { user_response_id: @ur.id, status: "test" }, xhr: true
      end

      it { expect(response.status).to eq 200 }
      it { expect(assigns[:user_response].owner_status).to eq "test" }
      it { expect(assigns[:user_response].comments.count).to eq 1 }
    end

    context "with same owner_status" do
      before do
        @ua = create :user_assignment
        @ur = create :user_response, user_assignment: @ua, owner_status: "hi!"
        sign_in @ua.user
        get :set_owner_status, params: { user_response_id: @ur.id, status: "hi!" }, xhr: true
      end

      it { expect(response.status).to eq 200 }
      it { expect(assigns[:user_response].owner_status).to eq "hi!" }
      it { expect(assigns[:user_response].comments.count).to eq 0 }
    end
  end
end
