module Coaching
  class StudentsController < ApplicationController
    layout 'coaching_layout'
    before_action :authenticate_user!
    before_action :set_resources, only: [:show, :edit, :update, :destroy]

    # GET /coaching/students/{student_username}
    def show
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_resources
        @student = User.find_by_username(params[:slug])
        @goals = @student.goals
        @meetings = @student.meetings

        @cohorts = current_user.cohorts if current_user.coach_or_higher?
        @students = @student.cohort.users if current_user.coach_or_higher?
      end
  end
end
