class Assignment::UserResponsesController < ApplicationController
  layout 'full_width_height_margins'
  respond_to :html
  authorize_resource

  def show
    @user_response = Assignment::UserResponse.find(params[:id])
    @new_ur_comment = Comment.new(commentable: @user_response, user: current_user)
    params[:user_id] = @user_response.user.id.to_s

    @assignment_group = @user_response.assignment_group
    @assignment_groups = current_user.active_assignment_groups
  end

  def index
  end

  def set_owner_status
    @user_response = Assignment::UserResponse.find(params[:user_response_id])
    return if @user_response.owner_status == params[:status]
    @user_response.owner_status = params[:status]
    if @user_response.save!
      Comment.create(commentable: @user_response,
                     user: @user_response.ag_owner,
                     flagged_as: "sys",
                     body: """
      #{@user_response.ag_owner.display_name} set the status to #{params[:status]}
      """
                    )
      respond_to do |format|
        format.js
      end
    else
      render js: "alert('Error setting status')"
    end
  end
end
