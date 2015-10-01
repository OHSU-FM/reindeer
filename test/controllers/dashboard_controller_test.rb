require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  test 'index redirects to sign_in' do
    get :index
    # Assert that the redirection was to the named route login_url
    assert_redirected_to new_user_session_path
  end

  test 'index shows dashboard after login' do
    login :user
    get :index
    # Assert select lets us use css selectors to 
    # make assertions about content received
    assert_select 'body#dashboard'
  end

  test 'user must have can_dashboard' do
    login :no_permissions_user
    get :index
    assert_redirected_to user_path(:no_permissions_user)
  end

  test 'user must be able to view widgets' do
    widget = create(:dashboard_widget)
    sign_in widget.dashboard.user
    get :index
    assert_select 'div.gridster div.inner-widget-container'
  end

end
