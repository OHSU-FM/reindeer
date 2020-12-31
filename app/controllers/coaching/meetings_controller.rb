module Coaching
  class MeetingsController < ApplicationController
    include Coaching::MeetingsHelper
    helper  :all

    def create
      @advisors = Advisor.all
      @events = Event.all  #where('start_date > ?', DateTime.now)
      @meeting = Meeting.create meeting_params
      EventMailer.notify_student.deliver_later

      respond_to do |format|
        if @meeting.save

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

    # def load_ipas_ipps
    #
    #   if params[:adviceCategory] == 'IPAS'
    #     @load_advice_subjects = hf_meeting_ipas_for_select
    #   else
    #     @load_advice_subjects = hf_meeting_ipps_for_select
    #   end
    #
    #   respond_to do |format|
    #     format.js
    #   end
    # end

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
        if @meeting.update_attributes(meeting_update_params)
          format.js { render action: 'update', status: :ok }
        else
          format.js { render json: { error: @meeting.errors }, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @meeting = Meeting.find params[:id]

      redirect_to coaching_index_path && return unless current_user.admin_or_higher?

      respond_to do |format|
        if @meeting.destroy
          format.js { render action: 'destroy', status: :ok }
        else
          format.js { render json: @meeting.errors, status: :unprocessable_entity }
        end
      end
    end



    private

    def meeting_params
      params.require(:coaching_meeting)
      .permit(:advice_category, :notes, :location, :date, :m_status, :user_id, :advisor_type, :advisor_id, :appointment_id, :event_id, subject: [])
    end

    def meeting_update_params
      params.permit(:id, :advice_category, :m_status, :notes, :advisor_type, :advisor_id, :appointment_id, :event_id, subject: [])
    end
  end
end
