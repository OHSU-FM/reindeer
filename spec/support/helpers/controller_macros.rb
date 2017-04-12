module ControllerMacros
  def login_admin
    login_user(FactoryGirl.create(:admin))
  end

  def login_user(user=nil, opts={})
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = user || FactoryGirl.create(options[:user] || :user)
    sign_in @user
  end
end
