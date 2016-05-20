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

  describe "owner" do
    before :each do
      @owner = @ag.owner
      sign_in @owner
    end

    it "can index" do
      get :index, assignment_group_assignment_group_id: @ag.id

      expect(response).to be_success
      expect(response).to render_template(:index)
    end

    it "can create new comment" do
      comment_params = attributes_for(:assignment_comment)

      expect {
        post :create, comment: comment_params,
        assignment_group_assignment_group_id: @ag.id
      }.to change(Assignment::AssignmentGroup::Comment, :count).by(1)
    end

    it "can delete their own comments" do
      comment = create :assignment_comment, user_id: @owner.id, commentable: @ag

      expect {
        delete :destroy, assignment_group_assignment_group_id: @ag.id, id: comment.id
      }.to change(Assignment::AssignmentGroup::Comment, :count).by(-1)
    end

    it "cannot delete other users' comments" do
      comment = create :assignment_comment, user_id: @ag.user_ids.first.to_s

      expect {
        delete :destroy, assignment_group_assignment_group_id: @ag.id, id: comment.id
      }.to change(Assignment::AssignmentGroup::Comment, :count).by(0)
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
