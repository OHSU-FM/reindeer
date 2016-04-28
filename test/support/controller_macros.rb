module ControllerMacros

  def login(user_type, *args )
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = FactoryGirl.create(user_type, *args)
    sign_in user 
    user
  end
end
