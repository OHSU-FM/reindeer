module Coaching
  class StudentsController < ApplicationController
    layout 'coaching_layout'
    before_action :authenticate_user!
    before_action :set_resources, only: [:show, :edit, :update, :destroy]

    helper_method :sort_column, :sort_direction

    # GET /coaching/students/{student_username}
    def show
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_resources
        @student = User.find_by_username(params[:slug])
        @goals = @student.goals.reorder("#{sort_column} #{sort_direction}").page(params[:page])
        @meetings = @student.meetings

        if current_user.coach?
          @cohorts = current_user.cohorts
          @students = @student.cohort.users
        elsif current_user.dean_or_higher?
          @cohorts = Cohort.includes(:users).includes(:owner).all
          @coaches = @cohorts.map(&:owner).uniq!
          @students = @cohorts.map(&:users).flatten
        end
      end

      def sortable_columns
        ["created_at", "name", "competency_tag", "g_status"]
      end

      def sort_column
        sortable_columns.include?(params[:column]) ? params[:column] : "created_at"
      end

      def sort_direction
        return "desc" if params[:direction].nil?
        %[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
      end
  end
end
