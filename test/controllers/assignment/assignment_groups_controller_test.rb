require "test_helper"

class Assignment::AssignmentGroupsControllerTest < ActionController::TestCase
  let(:admin) { users(:admin) }
  let(:coach) { users(:coach) }
  let(:student) { users(:student) }
  let(:ag) { assignment_assignment_groups(:one) }
  let(:ag2) { assignment_assignment_groups(:two) }
  let(:agt) { assignment_assignment_group_templates(:one) }

  test "not logged in should get redirect" do
    get :index
    assert_response :redirect
    flash[:alert].must_equal "You need to sign in or sign up before continuing."
  end

  # admin crud
  test "admin new" do
    sign_in admin

    get :new
    assert_response :success
  end

  test "admin create" do
    sign_in admin

    assert_difference('Assignment::AssignmentGroup.count') do
      post :create, assignment_assignment_group: {
        assignment_group_template_id: agt
      }
    end

    assert_redirected_to assignment_assignment_group_path(3)
  end

  test "admin read user should be redirected to assignment group" do
    # redirects to first available assignment_group
    sign_in admin

    get :index
    assert_redirected_to assignment_assignment_group_path(ag)
  end

  test "admin delete" do
    sign_in admin

    assert_difference('Assignment::AssignmentGroup.count', -1) do
      delete :destroy, assignment_group_id: ag2
    end

    assert_redirected_to assignment_assignment_groups_path
  end

end
