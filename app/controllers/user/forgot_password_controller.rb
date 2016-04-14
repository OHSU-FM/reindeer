class User::ForgotPasswordController < ApplicationController
    skip_before_filter :authenticate_user!
    layout 'full_width_margins'
    def new
    end

    ##
    # POST /users/forgot_password
    # Generate a new password recovery email for a user
    def create
      service = User::ForgotPasswordService.new(params[:login])
      service.perform!

      if service.errors.any?
        flash[:error] = service.error_message
        render :new
      else
        flash[:notice] = "Reset password instructions have been sent."
        redirect_to new_user_session_url
      end

    end

end
