module Coaching
  class StudentsController < ApplicationController
    layout 'coaching_layout'
    before_action :authenticate_user!
    before_action :set_resources, only: [:show, :edit, :update, :destroy]

    # GET /coaching/students/{student_email}
    def show
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
      def set_resources
        @student = User.find_by_username(params[:slug])
        @goals = @student.goals

        @cohorts = current_user.cohorts if current_user.coach_or_higher?
        @students = @student.cohort.users if current_user.coach_or_higher?
      end

      # Only allow a trusted parameter "white list" through.
      def goal_params
        params.fetch(:goal, {})
      end
  end
end
