require 'rails_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  
  let(:user){ FactoryGirl.create :admin }
  test 'login and browse' do

    https!
    get '/users/sign_in'
    assert_response :success
    
    post_via_redirect '/users/sign_in',
      user: {
        login: user.email, 
        password: user.password
      } 
    
    assert_equal '/dashboard', path
    assert_equal 'Signed in successfully.', flash[:notice]
    
    get '/ls_reports'
    assert_response :success
  end
end
