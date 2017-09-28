class GoalsController < ApplicationController
  before_action :load_goal, only: [:show, :edit, :update, :destroy]
  before_action :load_user, only: [:new]

  # GET /goals
  def index
    if current_user.cohorts.count > 0 # (current_user is coach or admin)
      @cohorts = current_user.cohorts
      @goals = @cohorts.first.users.first.goals
      @thread = CommentThread.find_by(second_user: @cohorts.first.users.first)
      @new_c = Comment.new(commentable: @thread, user: current_user)
    else # (current_user is student)
      @goals = current_user.goals
      @thread = CommentThread.where(second_user: current_user)
      @new_c = Comment.new(commentable: @thread, user: current_user)
    end

    if @cohorts.empty?
      @user = current_user
    else
      # TODO set this from params (cohort dropdown)
      @user = @cohorts.first.users.first
    end
  end

  # GET /goals/1
  def show
  end

  # GET /goals/new
  def new
    @goal = Goal.new(user: @user)
    @action_plan_item = @goal.action_plan_items.build
  end

  # GET /goals/1/edit
  def edit
    @action_plan_items = @goal.action_plan_items

    respond_to do |format|
      format.html
      format.json
    end
  end

  # POST /goals
  def create
    @goal = Goal.new(goal_params)
    if @goal.save
      redirect_to @goal, notice: 'Goal was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /goals/1
  def update
    if @goal.update_attributes(goal_params)
      redirect_to @goal, notice: 'Goal was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /goals/1
  def destroy
    @goal.destroy_attributes(goal_params)
    redirect_to goals_url, notice: 'Goal was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def load_goal
      @goal = Goal.find(params[:id])
    end

    def load_user
      @user = User.find(params[:user_id])
    end

    # Only allow a trusted parameter "white list" through.
    def goal_params
      params.require(:goal)
        .permit(:title, :description, :tag, :status, :target_date, :user_id,
      :type, :location,
      action_plan_items_attributes: [:id, :description, :goal_id, :_destroy])
    end
end
