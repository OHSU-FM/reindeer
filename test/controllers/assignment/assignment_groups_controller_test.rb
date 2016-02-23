require "test_helper"
require "factories/lime_survey"

class Assignment::AssignmentGroupsControllerTest < ActionController::TestCase
  def setup
    create_min_survey
    create_min_response
    spg = FactoryGirl.create(:student_permission_group)
    FactoryGirl.create(:assignment_group_template, permission_group: spg)
  end
  let(:admin) { FactoryGirl.create(:admin) }
  let(:coach) { FactoryGirl.create(:coach) }
  let(:student) { FactoryGirl.create(:student) }
  let(:agt) { Assignment::AssignmentGroupTemplate.first }
  let(:ag) { Assignment::AssignmentGroup.first }
  let(:ag2) { Assignment::AssignmentGroup.second }

  ##############################################################################
  # general tests
  ##############################################################################
  test "not logged in should get redirect" do
    get :index
    assert_response :redirect
    assert flash[:alert], "correct flash didn't trigger"
  end

  test "user should only see assignment groups they have access to" do
    new_ag = FactoryGirl.create(:assignment_group,
                       owner: admin,
                       assignment_group_template: agt)
    sign_in coach
    get :index
    refute_includes coach.assignment_groups, new_ag
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
    assert_redirected_to assignment_assignment_group_path(Assignment::AssignmentGroup.last)
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
