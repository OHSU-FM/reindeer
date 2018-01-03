class CommentsController < ApplicationController
  authorize_resource
  before_action :find_commentable

  def new
    @comment = Comment.new
  end

  def index
    @comments = @commentable.comments.order("updated_at DESC")
  end

  def create
    @comment = @commentable.comments.new comment_params
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to :back, notice: 'Your comment was successfully posted!'
    else
      redirect_to :back, notice: "Your comment wasn't posted!"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @comment.commentable }
      format.js   { render layout: false }
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body, :commentable_type, :commentable_id,
        :user_id, :flagged_as)
    end

    def find_commentable
      @commentable = Goal.find_by_id(params[:goal_id]) if params[:goal_id]
    end
end
