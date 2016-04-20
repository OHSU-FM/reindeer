class CommentsController < ApplicationController

  def create
    @comment = @commentable.comments.new comment_params
    @comment.user_id = current_user.id
    @comment.save
    redirect_to @commentable, notice: 'Comment saved successfully!'
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    if @comment.destroy
      redirect_to @commentable, notice: 'Comment deleted successfully!'
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body)
    end
end
