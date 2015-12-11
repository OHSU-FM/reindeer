class User::ForgotPasswordController < ApplicationController
    
    def new
    end

    ##
    # POST /users/forgot_password
    # Generate a new password recovery email for a user
    def create
      flash[:notice] = "Reset password instructions have been sent."
      user = User.find_login(params[:login]).first
      return unless user.present?
      user.send_reset_password_instructions
      redirect_to new_user_session_url
    end

end
