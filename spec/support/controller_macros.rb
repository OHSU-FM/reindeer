module ControllerMacros

  def login(user_type, *args )
    user = FactoryGirl.create(user_type, *args)
    login_user(user)
  end

  def login_user(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user 
    user
  end

  def it_requires_login
  end

end
