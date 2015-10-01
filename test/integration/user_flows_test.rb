require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  include Devise::TestHelpers

  test 'login and browse' do
    https!
    get '/users/sign_in'
    assert_response :success
    
    post_via_redirect '/users/sign_in', 
      username: users(:test).user, 
      password: users(:test).password
    
    assert_equal '/', path
    assert_equal 'Welcome', flash[:notice]
    
    get '/ls_reports'
    assert_response :success
  end
end
