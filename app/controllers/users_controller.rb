class UsersController < ApplicationController
  layout 'full_width_margins'

  # def index
  #   @user = User.find_by(username: params[:username].to_s)
  #   authorize! :read, @user
  # end

  def show
    @user = User.find_by(sid: params[:sid].to_s)
    authorize! :read, @user
  end

  def update
    # allow user to update password (unless ldap)
    @user = User.find_by(username: @user.username)
    # authorize! :update, @user
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


  def save_update_loa
    @user = params[:user]
      if User.where(sid: @user["sid"]).update(usrname: @user["username"], full_name: @user["full_name"], email: @user["email"],
         spec_program: @user["spec_program"], permission_group_id: @user["permission_group_id"],
         prev_permission_group_id: @user["prev_permission_group_id"])
        redirect_to main_app.dashboards_path, notice: 'Upldated Student LOA Data!'
      else
        redirect_to main_app.dashboards_path, alert: 'Student LOA data is NOT updated!!'
      end
  end

  def update_loa
    # allow user to update password (unless ldap)
    @permission_groups = PermissionGroup.where("title like ? ", '%Med2%').sort
    @user = User.find_by(sid: params[:sid].to_s)
    render :update_loa
  end


  private

  def user_update_params
    params.require(:user).permit(:sid, :subscribed, :permission_group_id, :prev_permission_group_id, :spec_program, :full_name, :username, :email, :coaching_type)
  end
end
