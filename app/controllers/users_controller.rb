class UsersController < ApplicationController
    layout 'full_width_margins'
    include UserAssignmentsHelper

    def show
        @user = User.find_by(:username=>params[:username].to_s)
        authorize! :read, @user
    end

    def update
        # allow user to update password (unless ldap)
        @user = User.find_by(:username=>params[:username].to_s)
        authorize! :update, @user

        respond_to do |format|
            if @user.update_attributes(user_update_params)
                flash[:notice] = 'Password Updated'
                format.html{ render :action=>:show }
                format.json{ render :json=>{},
                    :status=>:ok
                }
            else
                flash.now[:error] = 'Unable to update password'
                format.html{ render :action => :show}
                format.json{ render :json =>{},
                    :status => :unprocessable_entity
                }
            end
        end
    end

    def show_assignments
        @user = User.includes(:user_assignments).find_by(:username=>params[:username].to_s)
        authorize! :read, @user
        assignments = @user.user_assignments.order 'updated_at DESC'
        @assignment_group = Assignment::AssignmentGroup.new
        @active_assignments = VirtualAssignmentGroup.new(@user.active_assignments)
        @completed_assignments = VirtualAssignmentGroup.new(@user.completed_assignments)
    end

    private

    def user_update_params
        params.require(:user).permit(:password, :password_confirmation)
    end

end
