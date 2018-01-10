require 'rails_helper'

describe UsersController do
  let(:pw_args) { { password: :test_pass1, password_confirmation: :test_pass1 } }

  before :each do
    login :user
  end

  it "can change password" do
    patch :update, params: { username: subject.current_user.to_param, user: pw_args }
    assert_response :success
  end

  it "LDAP users cannot change their password" do
    subject.current_user.update!(is_ldap: true)
    patch :update, params: { username: subject.current_user.to_param, user: pw_args }
    assert_response 422
  end

  it "not allowed to change someone else's password" do
    user = create :user
    patch :update, params: { username: user.to_param, user: pw_args }
    assert_response 403
  end

  it "not allowed to view someone else's profile" do
    user = create :user
    get :show, params: { username: user.to_param }
    assert_response 403
  end
end
