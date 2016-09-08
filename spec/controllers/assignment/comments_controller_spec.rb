require 'spec_helper'
require 'assignment/comments_controller'

describe Assignment::AssignmentGroup::CommentsController do

  describe "get #index" do
    context "with signed in user" do
      before :each do
        @ag = create :assignment_group, :with_users
        sign_in @ag.owner
        get :index, assignment_group_assignment_group_id: @ag.id
      end

      it { expect(response.status).to eq 200 }
      it "should set commentable to ag" do
        expect(assigns[:commentable]).to eq @ag
      end
      it "should assign ag comments to @comments" do
        expect(assigns[:comments]).to eq @ag.comments
      end
    end

    context "without signed in user" do
      before :each do
        @ag = create :assignment_group, :with_users
        get :index, assignment_group_assignment_group_id: @ag.id
      end

      it { is_expected.to redirect_to new_user_session_path }
    end
  end
end

describe Assignment::UserResponse::CommentsController do

  describe "get #index" do
    context "with signed in user" do
      before :each do
        @ur = create :user_response, :with_comments
        sign_in @ur.user
        get :index, user_response_id: @ur.id
      end

      it { expect(response.status).to eq 200 }
      it "should set commentable to ur" do
        expect(assigns[:commentable]).to eq @ur
      end
      it "should assign ur comments to @comments" do
        expect(assigns[:comments]).to eq @ur.comments.order("updated_at DESC")
      end
    end

    context "without signed in user" do
      before :each do
        @ur = create :user_response, :with_comments
        get :index, user_response_id: @ur.id
      end

      it { is_expected.to redirect_to new_user_session_path }
    end
  end
end
