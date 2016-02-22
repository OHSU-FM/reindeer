require "test_helper"

class Assignment::AssignmentGroupsControllerTest < ActionController::TestCase
  let(:admin) { FactoryGirl.create(:admin) }
  let(:coach) { FactoryGirl.create(:coach) }
  let(:student) { FactoryGirl.create(:student) }
  let(:ag) { assignment_assignment_groups(:one) }
  let(:ag2) { assignment_assignment_groups(:two) }
  let(:agt) { assignment_assignment_group_templates(:one) }

  ##############################################################################
  # general tests
  ##############################################################################
  test "not logged in should get redirect" do
    get :index
    assert_response :redirect
    assert flash[:alert], "correct flash didn't trigger"
  end

  ##############################################################################
  # admin tests
  ##############################################################################
  test "admin can get new assignment_group" do
    sign_in admin

    get :new
    assert_response :success
  end

  #crud
  test "admin can create new assignment_group" do
    sign_in admin

    assert_difference('Assignment::AssignmentGroup.count') do
      post :create, assignment_assignment_group: {
        assignment_group_template_id: agt
      }
    end
    assert_redirected_to assignment_assignment_group_path(3)
    assert flash[:success], "correct flash didn't trigger"
  end

  test "admin get index should be redirected to assignment group" do
    # redirects to first available assignment_group
    sign_in admin

    get :index
    assert_redirected_to assignment_assignment_group_path(ag)
  end

  test "admin can update assignment_group" do
    sign_in admin

    put :update, assignment_group_id: ag,
      assignment_assignment_group: { title: "a different title" }
    assert_equal 'a different title', Assignment::AssignmentGroup.find(ag.id).title
    assert_redirected_to assignment_assignment_group_path(ag)
    assert flash[:success], "correct flash didn't trigger"
  end

  test "admin can delete assignment_group" do
    sign_in admin

    assert_difference('Assignment::AssignmentGroup.count', -1) do
      delete :destroy, assignment_group_id: ag2
    end
    assert_redirected_to assignment_assignment_groups_path
    assert flash[:success], "correct flash didn't trigger"
  end

  ##############################################################################
  # coach tests
  ##############################################################################
  test "coach can get new assignment_group" do
    sign_in coach

    get :new
    assert_response :success
  end

  # crud
  test "coach can create assignment_group" do
    sign_in coach

    assert_difference('Assignment::AssignmentGroup.count') do
      post :create, assignment_assignment_group: {
        assignment_group_template_id: agt
      }
    end
    assert_redirected_to assignment_assignment_group_path(3)
    assert flash[:success], "correct flash didn't trigger"
  end

  test "coach get index should be redirected to assignment group" do
    # redirects to first available assignment_group
    sign_in coach

    get :index
    assert_redirected_to assignment_assignment_group_path(ag)
  end

  test "coach can update assignment_group" do
    sign_in coach

    put :update, assignment_group_id: ag,
      assignment_assignment_group: { title: "a different title" }
    assert_equal 'a different title', Assignment::AssignmentGroup.find(ag.id).title
    assert_redirected_to assignment_assignment_group_path(ag)
    assert flash[:success], "correct flash didn't trigger"
  end

  test "coach can delete assignment_group" do
    sign_in coach

    assert_difference('Assignment::AssignmentGroup.count', -1) do
      delete :destroy, assignment_group_id: ag2
    end
    assert_redirected_to assignment_assignment_groups_path
    assert flash[:success], "correct flash didn't trigger"
  end

  ##############################################################################
  # student tests
  ##############################################################################
  test "student cannot get new assignment_group" do
    sign_in student

    get :new
    assert_redirected_to assignment_assignment_group_path(ag)
    assert flash[:warning], "correct flash didn't trigger"
  end

  # crud
  test "student cannot create assignment_group" do
    sign_in student

    refute_difference('Assignment::AssignmentGroup.count') do
      post :create, assignment_assignment_group: {
        assignment_group_template_id: agt
      }
    end
    assert_redirected_to assignment_assignment_group_path(ag)
    assert flash[:warning], "correct flash didn't trigger"
  end

  test "student get index should be redirected to first assignment group" do
    sign_in student

    get :index
    assert_redirected_to assignment_assignment_group_path(ag)
  end

  test "student cannot update assignment_group" do
    sign_in student

    put :update, assignment_group_id: ag,
      assignment_assignment_group: { title: "a different title" }
    assert_redirected_to assignment_assignment_group_path(ag)
    assert flash[:warning], "correct flash didn't trigger"
  end

  test "student cannot delete assignment_group" do
    sign_in student

    refute_difference('Assignment::AssignmentGroup.count') do
      delete :destroy, assignment_group_id: ag2
    end
    assert_redirected_to assignment_assignment_groups_path
    assert flash[:warning], "correct flash didn't trigger"
  end
end
