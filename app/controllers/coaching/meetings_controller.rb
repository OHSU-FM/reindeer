module Coaching
  class MeetingsController < ApplicationController
    include Coaching::MeetingsHelper
    helper  :all

    def create
      @advisors = Advisor.where(status: 'Active').order(:name)
      @events = Event.where('start_date > ?', DateTime.now)
      @meeting = Meeting.create meeting_params

      if params[:time_slot].present? and params[:startDate1].present?
        @meeting.advisor_discussed.delete_if(&:blank?)
        @meeting.advisor_outcomes.delete_if(&:blank?)
        # create Event record & advisor is creating a retro appointments/meetings
        end_date = (params[:startDate1].to_datetime + params[:time_slot].to_i.minutes).utc.strftime("%Y/%m/%d %I:%M %p - %A")
        start_date = params[:startDate1].to_datetime.utc.strftime("%Y/%m/%d %I:%M %p - %A")

        event = Event.create(title: @meeting.advisor_type, description: @meeting.advisor_type + " - " + current_user.full_name,
          start_date: start_date, end_date: end_date, user_id: @meeting.user_id, advisor_id: @meeting.advisor_id)
        @meeting.event_id = event.id
      else
        # student is createing a meeting/appointment record
        Event.find(@meeting.event_id).update(user_id: @meeting.user_id)

        if send_email_flag["OASIS"]["send_email"] ==  true
          event = Event.where("id = ? and start_date >= ?", @meeting.event_id, Date.today)
          if !event.empty?
            EventMailer.notify_student(@meeting, "Create").deliver_later
          end
        end
      end

      respond_to do |format|
        if @meeting.save
          flash[:aler] = 'Appointment/Meeting saved successfully!'
          format.js { render action: 'show', status: :created }
        else
          format.js { render json: { error: @meeting.errors }, status: :unprocessable_entity }
        end
      end

    end

    def show_detail
      @meeting = Meeting.find params[:id]
      respond_to do |format|
        format.js { render action: 'show_detail', status: :ok }
      end
    end

    def edit
      @meeting = Meeting.find params[:id]

      respond_to do |format|
        if @meeting.save
          format.js { render action: 'show', status: :created }
        else
          format.js { render json: { error: @meeting.errors }, status: :unprocessable_entity }
        end
      end
    end

    # this is dirty and manual because we're not using link_to in the view :(
    def update
      @meeting = Meeting.find params[:id]
      respond_to do |format|
        if @meeting.update(meeting_update_params)
          format.js { render action: 'update', status: :ok }
        else
          format.js { render json: { error: @meeting.errors }, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @meeting = Meeting.find params[:id]

      respond_to do |format|
        if send_email_flag["OASIS"]["send_email"] ==  true
          EventMailer.notify_student(@meeting, "Cancel").deliver_now  #notify_student_advisor_appt_cancel(@meeting).deliver_later
        end
        Event.find(@meeting.event_id).update(user_id: nil)  # release back to the queue
        if @meeting.destroy
          format.js { render action: 'destroy', status: :ok }
        else
          format.js { render json: @meeting.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def send_email_flag
      send_email_flag ||= YAML.load_file("config/OASIS_SendMail.yml")
      return send_email_flag
    end

    def meeting_params
      params.require(:coaching_meeting)
      .permit(:advice_category, :notes, :location, :date, :m_status, :user_id, :advisor_type, :advisor_id, :event_id,  :academic_discussed_other, :academic_outcomes_other,
        :career_discussed_other, :career_outcomes_other, :advisor_notes,
        subject: [], advisor_outcomes: [], advisor_discussed: [])
      # .permit( :notes,  :date, :m_status, :user_id, :advisor_type,
      #   :advisor_id, :event_id)
    end

    def meeting_update_params
      params.permit(:id, :advice_category, :m_status, :notes, :advisor_type, :advisor_id, :event_id, :academic_discussed_other, :academic_outcomes_other,
        :career_discussed_other, :career_outcomes_other, :advisor_notes,
        subject: [], advisor_outcomes: [], advisor_discussed: [])
    end
  end
end
