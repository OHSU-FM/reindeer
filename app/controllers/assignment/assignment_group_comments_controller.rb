module Assignment
  class AssignmentGroupCommentsController < Assignment::AssignmentBaseController
    respond_to :html

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
    end

    def destroy
    end

    protected

    def group_params
      params.require(:assignment_group_id)
    end

  end
end
