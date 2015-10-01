module ControllerMacros

  def login(user_type)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = FactoryGirl.create(user_type)
    sign_in user 
    user
  end
end
