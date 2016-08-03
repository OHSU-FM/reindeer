require 'rails_helper'

describe DashboardController do
  # Ask rspec to render views for inspection
  render_views

  it 'index redirects to sign_in' do
    get :index
    # Assert that the redirection was to the named route login_url
    assert_redirected_to new_user_session_path
  end

  it 'index shows dashboard after login' do
    login :user, :with_dashboard
    get :index
    # Assert select lets us use css selectors to 
    # make assertions about content received
    assert_select 'body#dashboard'
  end

  it 'user must have permission' do
    user = login :no_permissions_user
    get :index
    assert_redirected_to user_path(user)
  end

  it 'user must be able to view widgets' do
    login :user, :with_dashboard
    get :index
    assert_select 'div.gridster div.inner-widget-container'
  end

end
