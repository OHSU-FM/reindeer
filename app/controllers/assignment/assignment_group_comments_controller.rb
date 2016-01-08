module Assignment
  class AssignmentGroupCommentsController < Assignment::AssignmentBaseController
    respond_to :html, :json
    
    def index
      group = AssignmentGroup.includes(:comments).
        find(params[:assignment_group_id])
      @comments = group.comments
      authorize! :read, group
      reply_with @comments
    end

    def new
      @assignment_group = AssignmentGroup.find(group_params)
      authorize! :read, @assignment_group
      @comment = @assignment_group.comments.build(user_id: current_user.id)
    end

    # edit
    # show

    def update
      @comment = AssignmentComment.where(params[:comment_id])
    end

    def create
      @assignment_group = AssignmentGroup.find(group_params)
      authorize! :read, @assignment_group
      attributes = comment_params.merge(user_id: current_user.id)
      @comment = @assignment_group.comments.create(attributes)
      respond_with @comment
    end

    def destroy
    end

    protected

    def group_params
      params.require(:assignment_group_id)
    end

    def comment_params
      params.require(:assignment_assignment_comment).permit(:slug)
    end

  end
end
