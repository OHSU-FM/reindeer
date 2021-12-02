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

    def oasis_graphs
      if params[:id].present? and params[:id] == 'Graphs'
        @oasis_graphs_flag = true
        @events = Event.where("user_id is not NULL and advisor_id is not null")
        weekdays = @events.map{|e| e.start_date.strftime("%A")}.sort
        @weekdays_sorted = weekdays.tally
        hours = @events.map{|e| e.start_date.strftime("%I %p")}.sort
        @hours_sorted = hours.tally

      end

      respond_to do |format|
        format.js { render action: 'oasis_graphs', status: 200 }
      end
    end

    def advisor_reports
      if params[:id].present? and params[:id] != 'All'
        @meetings = Meeting.where(advisor_id: params[:id]).group(:user_id).count
      elsif params[:id].present? and params[:id] == 'All'
        @all_advisor_flag = true
        @meetings = Meeting.where("advisor_id is not NULL and event_id is not NULL and user_id is not NULL").order(:advisor_id).group(:advisor_id).count
      end

      respond_to do |format|
        format.js { render action: 'advisor_reports', status: 200 }
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
        @advisors = Advisor.where(status: 'Active').select(:id, :name, :advisor_type, :specialty).order(:name)

        #@events = Event.where('start_date > ?', DateTime.now).order(:id )
        @events = Event.where("start_date - INTERVAL '7 hour' > ? and user_id is NULL and advisor_id is NOT NULL", DateTime.now + 24.hours).order(:start_date)
        @permission_groups = PermissionGroup.where(" id >= ? and id <> ?", 16, 15)
        @appointments = Meeting.where(user_id: @student.id).where.not(event_id: [nil, ""])
        @artifacts = Artifact.where(user_id: @student.id, title: 'OASIS Documents')

        if current_user.coaching_type == 'student'
          @event_students = Event.where('start_date > ? and user_id = ?', DateTime.now, current_user.id).order(:id)
        end

        advisor = User.where(id: current_user.id).joins("INNER JOIN advisors on users.email = advisors.email").select("advisors.id, advisors.name, advisors.advisor_type").first

        if !advisor.nil?
          advisor_events = Event.where(advisor_id: advisor.id)
          @advisor_students = advisor_events.map{|a| a.user_id}.uniq.compact
          @advisor_type = advisor.advisor_type
          @advisor_id = advisor.id
        else
          @advisor_students = []
        end

        if current_user.student? && @student != current_user
          redirect_to root_path and return
        elsif current_user.coach?
          @cohorts = current_user.cohorts.where("title NOT LIKE ?", "%Med18%").order('title DESC')
          (redirect_to coaching_index_path and return) unless @cohorts.include? @student.cohort
          @students = @student.cohort.users
        elsif current_user.dean_or_higher?
          # exclude Med18, Med19 & Med20
          #@cohorts = Cohort.includes(:users).where("permission_group_id > ?", 6).includes(:owner).all
          @permission_groups = PermissionGroup.where(" id >= ? and id <> ?", 16, 15)
           #@coaches = @cohorts.map(&:owner).uniq!
           #@students = @cohorts.map(&:users).flatten
           advisor = Advisor.find_by(email: current_user.email)
           @students = @permission_groups.map(&:users).flatten
           if !advisor.nil?
             #@students = Event.where('advisor_id = ?', advisor.id).where.not(user_id: [nil, ""]).includes(:user).map(&:user).flatten.uniq!
             @event_students = Event.where('start_date > ? and advisor_id = ? and user_id is not NULL', DateTime.now, advisor.id).order(:id)
           else
             @event_students = Event.where('start_date > ? and user_id is not NULL', DateTime.now).order(:id)
             @students = @permission_groups.map(&:users).flatten
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
