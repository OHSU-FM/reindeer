class UsersController < ApplicationController
  layout 'full_width_margins'

  # def index
  #   @user = User.find_by(username: params[:username].to_s)
  #   authorize! :read, @user
  # end

  def show
    @user = User.find_by(username: params[:username].to_s)
    authorize! :read, @user
  end

  def update
    # allow user to update password (unless ldap)
    @user = User.find_by(username: params[:username].to_s)
    authorize! :update, @user
    respond_to do |format|
      if @user.update(user_update_params)
        flash[:notice] = 'Password Updated'
        format.html{ render action: :show }
        format.json{ render json: {}, status: :ok }
      else
        flash.now[:error] = @user.errors.full_messages
        format.html{ render action: :show, status: :unprocessable_entity }
        format.json{ render json: {}, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_update_params
    params.require(:user).permit(:password, :password_confirmation, :subscribed)
  end
end
