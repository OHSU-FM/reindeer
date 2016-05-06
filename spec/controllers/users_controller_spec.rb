require 'rails_helper'

describe UsersController do
  let(:pw_args) { { password: :test_pass1,
      password_confirmation: :test_pass1} 
  } 
  before :each do
    login :user
  end

  it "can change password" do
    put :update, username: subject.current_user.username, user: pw_args
    assert_response :success
  end

  it "LDAP users cannot change their password" do
    subject.current_user.is_ldap = true
    subject.current_user.save!
    put :update, username: subject.current_user.username, user: pw_args
    assert_response 422
  end
  
  it "not allowed to change someone else's password" do
    user = create :user
    put :update, username: user.username, user: pw_args
    assert_response 403
  end

  it "not allowed to view someone else's profile" do
    user = create :user
    get :show, username: user.username
    assert_response 403
  end

end

