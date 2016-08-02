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
    @comment.destroy

    if @comment.destroy
      redirect_to @commentable, notice: 'Comment deleted successfully!'
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body, :commentable_type, :commentable_id,
                                     :user_id, :flagged_as)
    end
end
