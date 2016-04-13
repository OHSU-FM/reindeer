class Assignment::UserResponsesController < ApplicationController
  layout 'full_width_height_margins'
  respond_to :html
  authorize_resource

  def show
    @user_response = Assignment::UserResponse.find(params[:id])
    params[:user_id] = @user_response.user.id.to_s
    @assignment_group = @user_response.assignment_group
    @assignment_groups = current_user.active_assignment_groups
  end
end
