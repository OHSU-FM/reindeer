class Assignment::UserAssignmentsController < Assignment::AssignmentBaseController
  def index
    @assignments = Assignment::ListAssignmentsService.new(current_user, params[:username])
    respond_with @assignments
  end

  def show
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
