class GoalsController < ApplicationController
  before_action :load_goal, only: [:show, :edit, :update, :destroy]
  before_action :load_user, only: [:new]
  before_action :find_commentable, only: [:show, :index]
  before_filter "save_my_previous_url"
  
  # GET /goals
  def index


    if current_user.cohorts.count > 0 # (current_user is coach or admin)
      @cohorts = current_user.cohorts

      #@goals = @cohorts.first.users.first.goals
      @thread = CommentThread.find_by(second_user: @cohorts.first.users.first)
      @new_c = Comment.new(commentable: @thread, user: current_user)
      @goals = Goal.where(user_id:params[:user_id], goal_type: 'Goal')
      @meetings = Goal.where(user_id:params[:user_id], goal_type: 'Meeting')
      if !@goals.empty?
        @user_id = @goals.first.user_id
      end 
      load_student


    else if @cohort.nil? # (current_user is coach)
            @cohorts = Cohort.where('title LIKE ?', "#{current_user.full_name}%").all
          
            @thread = CommentThread.find_by(second_user: @cohorts.first.users.first)
            @new_c = Comment.new(commentable: @thread, user: current_user)
            @goals = Goal.where(user_id:params[:user_id], goal_type: 'Goal')
            @meetings = Goal.where(user_id:params[:user_id], goal_type: 'Meeting')
            if !@goals.empty?
              @user_id = @goals.first.user_id
            end 

          else
            # (current_user is student)
            @goals = current_user.goals
            @thread = CommentThread.where(second_user: current_user)
            @new_c = Comment.new(commentable: @thread, user: current_user)
          end
    end

    if @commentable.nil?
        @no_comments = 0
    else
        @no_comments = @commentable.count
    end

    if @cohorts.empty?
      @user = current_user
    else
      # TODO set this from params (cohort dropdown)
      @user = @cohorts.first.users.first
    end

    @back_url = session[:my_previous_url]


  end

  # GET /goals/1
  def show
    if params[:goal_type] == 'Goal'
      @goal = Goal.find_by(id: params[:id], goal_type: 'Goal')   #find(params[:id])
      @action_plan_items = @goal.action_plan_items
    else
      @meeting = Goal.find_by(id: params[:id], goal_type: params[:goal_type])
    end

    binding.pry
  end

  # GET /goals/new
  def new
    case params[:goal_type]
    when 'Goal'
      @goal = Goal.new(user: @user)
      @action_plan_item = @goal.action_plan_items.build
    when 'Meeting'
      @goal_type = 'Meeting'
      @goal = Goal.new(user: @user)
    else
      redirect_to @goal, notice: '** Invalid Goal Type ***'
    end   
  end


  # GET /goals/1/edit
  def edit
    @action_plan_items = @goal.action_plan_items

    respond_to do |format|
      format.html { render :action=>:edit }
      format.json { render :action=>:edit }

    end
  end

  # POST /goals
  def create
    @goal = Goal.new(goal_params)
    binding.pry
    if @goal.save
      redirect_to @goal, notice: 'Goal was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /goals/1
  def update
    binding.pry
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

    def load_student
        @cohorts.each do |c|
          c.title = c.title + ' (' +  User.find(c.user_id).full_name + ')'
        end 
    end 

    def find_commentable
      #@commentable = Goal.find(user_id: params[:user_id])
      @commentable = Comment.find_by(commentable_id: params[:id]) if params[:id]

    end 

    # Only allow a trusted parameter "white list" through.
    def goal_params
      params.require(:goal)
        .permit(:title, :description, :tag, :status, :target_date, :user_id,
      :goal_type, :location,
      action_plan_items_attributes: [:id, :description, :goal_id, :_destroy])
    end

    def save_my_previous_url
      session[:my_previous_url] = URI(request.referer || '').path
    end 

end
