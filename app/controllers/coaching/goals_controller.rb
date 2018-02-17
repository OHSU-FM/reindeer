module Coaching
  class GoalsController < ApplicationController

    def create
      @goal = Goal.create goal_params

      respond_to do |format|
        if @goal.save
          format.js { render action: 'show', status: :created }
        else
          format.js { render json: @goal.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @goal = Goal.find params[:id]

      if current_user.admin_or_higher?
        @goal.destroy
      else
        redirect_to coaching_students_path
      end
    end

    private

    def goal_params
      params.require(:goal)
      .permit(:name, :description, :competency_tag, :target_date, :status, :user_id)
    end
  end
end
