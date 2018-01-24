module Coaching
  class StudentsController < ApplicationController
    layout 'coaching_layout'
    before_action :set_goal, only: [:show, :edit, :update, :destroy]

    # GET /coaching/students
    # only accessible by coach and above
    def index
      # @goals = goals for first student
      # redirect_to show(cohorts.first.users.first)
    end

    # GET /coaching/students/{student_email}
    def show
      # @student User.find_by_email(params[:email])
      # @goals = @student.goals
      # @new_goal = Goal.new(user: @student)
    end

    # GET /goals/new
    # probably an ajax route?
    def new
      @goal = Goal.new
    end

    # GET /goals/1/edit
    def edit
    end

    # POST /coaching/students/{student_email}/goals
    # definitely an ajax route (no html render option)
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
      if @goal.update(goal_params)
        redirect_to @goal, notice: 'Goal was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /goals/1
    # only accessible by admin
    def destroy
      @goal.destroy
      redirect_to goals_url, notice: 'Goal was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_goal
        @goal = Goal.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def goal_params
        params.fetch(:goal, {})
      end
  end
end
