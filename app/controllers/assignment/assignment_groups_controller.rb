class Assignment::AssignmentGroupsController < Assignment::AssignmentBaseController
  respond_to :html, :json
  authorize_resource 
   
  def index
    @assignment_groups = Assignment::AssignmentGroup.all
    respond_with @assignment_groups
  end

  def show
    @assignment_group = Assignment::AssignmentGroup.find(params[:id])
    respond_with @assignment_group
  end

  def new
    @assignment_group = Assignment::AssignmentGroup.new
    respond_with @assignment_group
  end

  def create
    @assignment_group = Assignment::AssignmentGroup.create create_params
    respond_with @assignment_group
  end

  def edit
    @assignment_group = Assignment::AssignmentGroup.find(params[:id])
    respond_with @assignment_group
  end

  def update
    @assignment_group = Assignment::AssignmentGroup.find(params[:id])
    @assignment_group.update(update_params)
    respond_with @assignment_group
  end

  def destroy
    @assignment_group = Assignment::AssignmentGroup.find(params[:id])
    @assignment_group.destroy
  end

  protected
  
  def create_params
    update_params
  end

  def update_params
    result = params.require(:assignment_assignment_group).permit!()
    if cannot?(:sign_for, User) || result[:user_id].nil?
      result[:user_id] = current_user.id
    end
    result
  end

end
