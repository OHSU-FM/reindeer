class GoalsController < ApplicationController
  before_action :set_goal, only: [:show, :edit, :update, :destroy]

  # GET /goals
  def index

    #@cohorts = Cohort.select ("DISTINCT title")
    #@cohorts = @cohorts.sort_by { |u| u.title }
    @student_cohorts = []
    @cohorts = current_user.cohorts    #.select ("DISTINCT title")

    @r_cohorts = current_user.cohorts
    @r_cohorts.each do |u|
      student = User.find(u.user_id)
      @student_cohorts.push student.full_name
         
    end 

    @goals = Goal.where(user_id:params[:user_id])


  end

  # GET /goals/1
  def show
    @goal = Goal.find(params[:id])   #Goal.all #current_user.goals

  end

  # GET /goals/new
  def new
    @goal = Goal.new
    5.times { @goal.action_plan_items.build}
  end

  # GET /goals/1/edit
  def edit

    @goal = Goal.find(params[:id])
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
    @goal = Goal.find(params[:id])
    #@goal.action_plan_items.each do |a|
    #  a.goal_id = params[:id]
    #end 

    #binding.pry

    if @goal.update_attributes(goal_params)
      redirect_to @goal, notice: 'Goal was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /goals/1
  def destroy
    binding.pry
    @goal.destroy_attributes(goal_params)
    redirect_to goals_url, notice: 'Goal was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_goal
      @goal = Goal.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def goal_params
      #params[:id]
      params.require(:goal).permit(:title, :description, :tag, :status, :target_date, :user_id, :type, :location,
                                   action_plan_items_attributes:[:id, :description, :goal_id, :_destroy])


    end
end
