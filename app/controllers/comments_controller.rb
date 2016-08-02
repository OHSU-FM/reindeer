class CommentsController < ApplicationController
  authorize_resource

  def index
    @comments = @commentable.comments.order("updated_at DESC")
  end

  def create
    @commentable = comment_params[:commentable_type].constantize.find(comment_params[:commentable_id])
    @comment = Comment.new(comment_params, user_id: current_user.id)
    if @comment.save
      render partial: "comments/#{@comment.row_partial_path}",
        locals: { comment: @comment, commentable: @commentable }, layout: false, status: :created
    else
      render js: "alert('error saving comment')"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      render json: @comment, status: :ok
    else
      render js: "alert('Error deleting comment')"
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body, :commentable_type, :commentable_id,
                                     :user_id, :flagged_as)
    end
end
