class Assignment::CommentsController < CommentsController
  before_action :set_commentable

  private

    def set_commentable
      if params[:assignment_group_assignment_group_id]
        @commentable = Assignment::AssignmentGroup.find(params[:assignment_group_assignment_group_id])
      elsif params[:user_response_id]
        @commentable = Assignment::UserResponse.find(params[:user_response_id])
      end
    end
end

class Assignment::AssignmentGroup::CommentsController < Assignment::CommentsController
end

class Assignment::UserResponse::CommentsController < Assignment::CommentsController
end
