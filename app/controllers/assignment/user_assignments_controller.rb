class Assignment::UserAssignmentsController < Assignment::AssignmentBaseController
  layout 'full_width_height_margins'
  respond_to :html
  authorize_resource

  def index
  end

  def show
    @user_assignment = Assignment::UserAssignment.find params[:id]
    if @user_assignment.is_shallow?
      redirect_to assignment_user_response_path(@user_assignment.user_responses.first)
    end
    @assignment_groups = current_user.active_assignment_groups
    @assignment_group = @user_assignment.assignment_group
  end

  def new
    @user_assignment = Assignment::UserAssignment.new
    @assignment_group = Assignment::AssignmentGroup.find params[:assignment_group_id]
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
