class Assignment::AssignmentCommentsController < Assignment::AssignmentBaseController
  respond_to :html, :json
  authorize_resource

  def index
    @assignment_comments = Assignment::AssignmentComment.all
    respond_with @assignment_comments
  end

  def show
    @assignment_comment = Assignment::AssignmentComment.find(params[:id])
    respond_with @assignment_comment
  end

  def new
    @assignment_comment = Assignment::AssignmentComment.new
    respond_with @assignment_comment
  end

  def create
    @assignment_comment = Assignment::AssignmentComment.create create_params
    respond_with @assignment_comment
  end

  def edit
    @assignment_comment = Assignment::AssignmentComment.find(params[:id])
    respond_with @assignment_comment
  end

  def update
    @assignment_comment = Assignment::AssignmentComment.find(params[:id])
    @assignment_comment.update(update_params)
    respond_with @assignment_comment
  end

  def destroy
    @assignment_comment = Assignment::AssignmentComment.find(params[:id])
    @assignment_comment.destroy
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
