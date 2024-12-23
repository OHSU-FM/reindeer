module Coaching
  class StudentsController < ApplicationController
    layout 'coaching_layout'
    before_action :authenticate_user!
    include DashboardHelper
    authorize_resource only: :show
    before_action :set_resources, only: [:show]

    helper_method :sort_column, :sort_direction, :oasis_graphs
    helper  :all
    include StudentsHelper
    include MeetingsHelper
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

        @valid_advisor = Advisor.find_by(email: current_user.email, status: 'Active')
        if @valid_advisor.nil?
          @events = Event.where("user_id is not NULL and advisor_id is not null")
        else
          @events = Event.where("user_id is not NULL and advisor_id=?", @valid_advisor.id)
        end

        weekdays = @events.map{|e| e.start_date.strftime("%A")}.sort
        @weekdays_sorted = weekdays.tally

        hours = @events.map{|e| e.start_date.strftime("%I %p")}.sort
        @hours_sorted = hours.tally

      end
      # commented out on 3/7/2024 - not being used!
      # if current_user.coaching_type != 'student'
      #   @students_array, @tot_failed_arry = hf_scan_fom_data(19) # Med25 cohort only
      # end
      respond_to do |format|
        format.js { render action: 'oasis_graphs', status: 200 }
      end
    end

    def advisor_reports

      if params[:advisor_id].present? and !params[:advisor_id].include? 'All'
        if params[:Status].present? and !params[:Status].include? 'All'
           @code = "Individual"
           @meetings = Meeting.where("advisor_id = ? and m_status = ? and created_at >= ? and created_at <= ?", params[:advisor_id], params[:Status], params[:StartDate], params[:EndDate]).order(created_at: :desc)
        else
          @code = "Aggregate"
          @meetings = Meeting.where("advisor_id = ? and created_at >= ? and created_at <= ?", params[:advisor_id], params[:StartDate], params[:EndDate]).group(:user_id).count

        end
      elsif params[:advisor_id].present? and params[:advisor_id].include? 'All' and !params[:Status].include? 'All'

        @code = "Individual"
        @meetings = Meeting.where("m_status = ? and created_at >= ? and created_at <= ?", params[:Status], params[:StartDate], params[:EndDate]).order(created_at: :desc)
        hf_create_file(@meetings, "oasis_status_report.csv")
      elsif params[:advisor_id].present? and params[:advisor_id].include? 'All' and params[:Status] == 'All'
        @all_advisor_flag = true
        @meetings = Meeting.where("advisor_id is not NULL and event_id is not NULL and user_id is not NULL and created_at >= ? and created_at <= ?", params[:StartDate], params[:EndDate])
                        .order(:advisor_id).group(:advisor_id).count

        @advisor_types = Advisor.distinct.pluck(:advisor_type).sort
        # @appt_counts = Event.joins(:advisor).
        #                 where("events.user_id is not null").
        #                 group(:advisor_type, :name).
        #                 order(:advisor_type, :name).count  #return with ["Academic", "Antsey, James"] => 181, ...

        @appt_counts = Advisor.where(status: 'Active').joins(:meetings).
                        where("meetings.user_id is not null and meetings.advisor_id = advisors.id and meetings.created_at >= ? and meetings.created_at <= ?", params[:StartDate], params[:EndDate]).
                        group(:advisor_type, :name).order(:advisor_type, :name).count
      elsif !params[:advisor_id].present?
        @code = "Individual"
        @valid_advisor = Advisor.find_by(email: current_user.email)
        if params[:Status].present? and params[:Status] != 'All'
          @meetings = Meeting.where("advisor_id = ? and m_status = ? and created_at >= ? and created_at <= ?", @valid_advisor.id, params[:Status], params[:StartDate], params[:EndDate]).order(created_at: :desc)
        else
          @meetings = Meeting.where("advisor_id = ? and created_at >= ? and created_at <= ?", @valid_advisor.id, params[:StartDate], params[:EndDate]).order(created_at: :desc)
        end

      end

      respond_to do |format|
        format.js { render action: 'advisor_reports', status: 200 }
      end
    end

    def contact_form
      if params[:message].present?
        ActionMailer::Base.mail(from: params[:from], to: params[:to], subject: params[:subject], body: params[:message].html_safe, content_type: 'text/html').deliver
        flash[:send_alert] = "Your email was sent!"
      end
    end

    def file_download
      if params[:file_name].present?
        private_download params[:file_name]
      end

    end



    private

      def private_download in_file
         send_file  "#{Rails.root}/tmp/#{in_file}", type: 'text', disposition: 'download'
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_resources
        #@student = User.find_by_username(params[:slug])
        @student = User.where("username = ?", params[:slug]).first
        @@student_g = @student

        #@goals = @student.goals.reorder("#{sort_column} #{sort_direction}").page(params[:page])
        @meetings = @student.meetings.order('created_at DESC').paginate(page:params[:page], per_page: 20).fast_page
        #-- room resource is being disabled
        #@messages = @student.room.messages.order(:created_at)
        #@room_id = @student.room.id

        @advisors = Advisor.where(status: 'Active').select(:id, :name, :advisor_type, :specialty).order(:name).load_async
        @advisor_types = @advisors.map{|a| a.advisor_type}.uniq

        #@events = Event.where("start_date - INTERVAL '7 hour' > ? and user_id is NULL and advisor_id is NOT NULL", DateTime.now + 17.hours).order(:start_date).load_async
        # @events = Event.where("start_date - INTERVAL '7 hour' > ? and start_date-INTERVAL '7 hour' <= ? and user_id is NULL and advisor_id is NOT NULL",
        #   DateTime.now + 24.hours, DateTime.now + 8.days).order(:start_date)

        #@permission_groups = PermissionGroup.where(" id >= ? and id <> ?", 17, 15)
        @appointments = Meeting.where(user_id: @student.id).where.not(event_id: [nil, ""]).load_async
        @artifacts = Artifact.where(user_id: @student.id, title: 'OASIS Documents').load_async

        if current_user.coaching_type == 'student'
          @event_students = Event.where('start_date > ? and user_id = ?', DateTime.now, current_user.id).order(:id).load_async
        end

        advisor = User.where(id: current_user.id).joins("INNER JOIN advisors on users.email = advisors.email").select("advisors.id, advisors.name, advisors.advisor_type").first

        if !advisor.nil?
          # advisor_events = Event.where(advisor_id: advisor.id)
          # @advisor_students = advisor_events.map{|a| a.user_id}.uniq.compact

          advisor_students_query = "select users.full_name, users.username, permission_groups.title, count(meetings.user_id) from meetings, users, permission_groups " +
                                    "where advisor_id=? and " +
                                    "users.id = meetings.user_id and " +
                                    "users.permission_group_id >= 19 and " +
                                    "users.permission_group_id = permission_groups.id " +
                                    "group by users.full_name, users.username, permission_groups.title, meetings.user_id " +
                                    "order by permission_groups.title DESC, users.full_name"
          @advisor_students = Student.execute_sql(advisor_students_query, advisor.id).to_a

          @advisor_type = advisor.advisor_type
          @advisor_id = advisor.id
        else
          @advisor = Advisor.find_by(email: current_user.email)
          # if !@advisor.nil?
          #   @advisor_type = @advisor.advisor_type
          #   @advisor_id = @advisor.id
          # end
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
          @permission_groups = PermissionGroup.where(" id >= ? and id <> ?", 19, 15).load_async
           #@coaches = @cohorts.map(&:owner).uniq!
           #@students = @cohorts.map(&:users).flatten
           advisor = Advisor.find_by(email: current_user.email)
           @students = @permission_groups.map(&:users).flatten
           if !advisor.nil?
             #@students = Event.where('advisor_id = ?', advisor.id).where.not(user_id: [nil, ""]).includes(:user).map(&:user).flatten.uniq!
             @event_students = Event.where('start_date > ? and advisor_id = ? and user_id is not NULL', DateTime.now, advisor.id).order(:id).load_async
             ## aded ib 1/18/2022
             # commented out on 3/7/2024 not being used
             # if current_user.coaching_type != 'student'
             #   @students_array, @tot_failed_arry = hf_scan_fom_data(19) # Med25 cohort only
             # end
           else
             @event_students = Event.where('start_date > ? and user_id is not NULL', DateTime.now).order(:id).load_async
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
