require 'spec_helper'
require 'assignment/comments_controller'

describe Assignment::AssignmentGroup::CommentsController do

  before :each do
    @ag = create :assignment_group, :with_users
  end

  describe "not logged in user" do
    it "get index should redirect to sign in" do
      get :index, assignment_group_assignment_group_id: @ag.id
      expect(subject).to redirect_to new_user_session_path
    end
  end
end

describe Assignment::UserResponse::CommentsController do

  before :each do
    @ur = create :user_response, :with_comments
  end

  describe "not logged in" do
    it "should redirect to sign in" do
      get :index, user_response_id: @ur.id
      expect(subject).to redirect_to new_user_session_path
    end
  end
end
