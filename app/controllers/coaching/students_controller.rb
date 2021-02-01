module Coaching
  class StudentsController < ApplicationController
    layout 'coaching_layout'
    before_action :authenticate_user!
    authorize_resource only: :show
    before_action :set_resources, only: [:show]

    helper_method :sort_column, :sort_direction
    helper  :all
    # GET /coaching/students/{student_username}
    def show

      respond_to do |format|
        format.json
        format.html
      end
    end

    def search_goals
      @goals = User.find_by_username(params[:slug]).goals.search(goal_search_params)

      respond_to do |format|
        format.js { render action: 'search_goals', status: 200 }
      end
    end

    def completed_goals
      if params[:completed_goal].present? && params[:completed_goal] == "true"
        @goals = User.find_by_username(params[:slug]).goals.completed.page(params[:page])
      else
        @goals = User.find_by_username(params[:slug]).goals.page(params[:page])
      end

      respond_to do |format|
        format.js { render action: 'completed_goals', status: 200 }
      end
    end

    def search_meetings
      @meetings = User.find_by_username(params[:slug]).meetings.search(meeting_search_params)

      respond_to do |format|
        format.js { render action: 'search_meetings', status: 200 }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_resources
        #@student = User.find_by_username(params[:slug])
        @student = User.where("username = ?", params[:slug]).first

        @@student_g = @student

        #@goals = @student.goals.reorder("#{sort_column} #{sort_direction}").page(params[:page])

        @meetings = @student.meetings.order('created_at DESC')
        @messages = @student.room.messages.order(:created_at)
        @room_id = @student.room.id
        @advisors = Advisor.all
        @events = Event.where('start_date > ?', DateTime.now).order(:id )
        @permission_groups = PermissionGroup.where(" id >= ? and id <> ?", 13, 15)
        @appointments = Meeting.where(user_id: @student.id).where.not(event_id: [nil, ""])

        @permission_groups = PermissionGroup.where(" id >= ? and id <> ?", 13, 15)
        @event_students = Event.where('start_date > ? and user_id = ?', DateTime.now, current_user.id).where.not(user_id: [nil, ""]).order(:id)

        if current_user.student? && @student != current_user

          redirect_to root_path and return
        elsif current_user.coach?
          @cohorts = current_user.cohorts.where("title NOT LIKE ?", "%Med18%").order('title DESC')
          (redirect_to coaching_index_path and return) unless @cohorts.include? @student.cohort
          @students = @student.cohort.users
        elsif current_user.dean_or_higher?
          # exclude Med18, Med19 & Med20
          @cohorts = Cohort.includes(:users).where("permission_group_id > ?", 6).includes(:owner).all
           #@coaches = @cohorts.map(&:owner).uniq!
           #@students = @cohorts.map(&:users).flatten
           advisor = Advisor.find_by(email: current_user.email)
           if !advisor.nil?
             @students = Event.where('start_date > ? and advisor_id = ?', DateTime.now, advisor.id).where.not(user_id: nil).includes(:user).map(&:user).flatten.uniq!
             @event_students = Event.where('start_date > ? and advisor_id = ?', DateTime.now, advisor.id).where.not(user_id: [nil, ""]).order(:id)
             if @students.nil?
               #@students = Event.where(advisor_id: advisor.id).where.not(user_id: nil).includes(:user).map(&:user).flatten.uniq!
               @event_students = nil #Event.where('start_date > ?', DateTime.now).where.not(user_id: [nil, ""]).order(:id)
               @students = @cohorts.map(&:users).flatten
             end
           else
             @students = @cohorts.map(&:users).flatten
             #@students = Event.where('start_date > ?', DateTime.now).where.not(user_id: nil).includes(:user).map(&:user).flatten.uniq!
            byebug
           end

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

      def goal_search_params
        params.permit(:goal_search)[:goal_search]
      end

      def meeting_search_params
        params.permit(:meeting_search)[:meeting_search]
      end
  end
end
