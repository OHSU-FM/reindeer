class EventsController < ApplicationController
  layout 'full_width_margins'
  skip_before_action :verify_authenticity_token, only: [:update]
  before_action :authenticate_user!
  before_action :set_resources
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  include EventsHelper
  include AdvisorsHelper

  # GET /events
  # GET /events.json
  def index
    # advisor wants to see other advisor's appointment
    @events = Event.where('start_date > ?', DateTime.now)  #.order(start_date: :desc)
    advisor = Advisor.find_by(email: current_user.email)
    if !advisor.nil?
      @advisor_name = advisor.name
    end
    #   @events = Event.where('advisor_id=? and start_date > ?', advisor.id, DateTime.now).order(start_date: :desc) #.paginate(:page => params[:page], :per_page => 10)
    # else
    #   @events = Event.where('start_date > ?', DateTime.now).order(start_date: :desc) #.paginate(:page => params[:page], :per_page => 10)
    # end

    @events.each do |event|
      if !event.user_id.nil?
        full_name = User.find(event.user_id).full_name  #hf_full_name (event.id)
        event.title = event.title + ' - ' + full_name
      end

    end
    respond_to do |format|
      format.json
      format.html
    end
  end

  def check_events
    if params[:event_id]
      @event = Event.where(id: params[:event_id], user_id: nil)
      if @event.empty?
        @event = {"Status" => "Appointment is TAKEN, please select another one!", "event_id" => params[:event_id]}
      else
        @event =  {"Status" => "Appointment is AVAILABLE!", "event_id" => params[:event_id]}
      end
    end

    respond_to do |format|
      format.json {render json: @event, status: 200}
      format.html
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_events
    @advisor_events = Event.where(advisor_id: params[:advisor_id])
    respond_to do |format|
      format.js {render action: 'get_events', status: 200}
    end
  end

  def create_batch_appointments

    if params[:advisor_type].present?
      @advisor_type = params[:advisor_type]
      @advisor = params[:advisor]
      @time_slot = params[:time_slot]
      @weekly_recurrences = params[:weekly_recurrences]
      session[:advisor_type] = @advisor_type
      session[:advisor] = @advisor

      #@appointments = Event.enumerate_hours(params[:start_date], params[:end_date], params[:time_slot], @advisor_type, @weekly_recurrences)
      @appointments = Event.enumerate_hours2(params[:startDate1], params[:endDate1], params[:time_slot], @advisor_type, @weekly_recurrences)

      respond_to do |format|
        #format.html
        format.js { render action: 'display_batch_appointments', status: 200 }
      end

    end
  end

  def create_random_appointments
    @advisors = Advisor.where(status: 'Active').order(:name)
    @advisor = Advisor.find_by(email: current_user.email)
    if params[:time_slot].present?
      @time_slot = params[:time_slot]
      if @advisor.nil?
        @advisor = Advisor.find_by(id: params[:advisor])
      end
      #params[:advisor] = @advisor.id.to_s  # need the advisor id for display_batch_appointments, and th id need to be string
      @advisor_type = @advisor.advisor_type
      # gahter up all the startDates in the params controller
      params_hash = params.as_json.to_hash
      startDates = params_hash.map{|key, val| val if key.include? "rstartDate"}.compact  #
      count = startDates.compact_blank.count
      recur_hash = {}
      start_date_hash = {}

      for c in 1..count
        recur_hash["weekly_recurrences#{c}"] = params_hash["weekly_recurrences#{c}"]
        start_date_hash["rstartDate#{c}"] = params_hash["rstartDate#{c}"]
      end
      @appointments = Event.reformat_startDate(start_date_hash, recur_hash, @time_slot, count)
      
      respond_to do |format|
        #format.html
        format.js { render action: 'display_random_appointments', status: 200 }
      end
    end
  end

  def save_all_random

    @appointments = JSON.parse(params[:appointments])

    @appointments.each do |appointment|
      data = appointment.split("|")
      start_date = hf_format_datetime(data[0])
      end_date = hf_format_datetime(data[1])
      advisor_id = data[2].to_i
      advisor = Advisor.find(advisor_id)
      title = advisor.advisor_type + ' Advisor'
      description = title + " - " + advisor.name
      #appt = Event.where(advisor_id: advisor_id, title: title, description: description, start_date: start_date2)
      if Event.exists?(title: title, description: description, start_date: Time.parse(start_date), end_date: Time.parse(end_date), advisor_id: advisor_id)
        notice_msg = "Found Existing Appointment(s), Not All Appointments were Created!"
      else
        Event.where(title: title, description: description, start_date: Time.parse(start_date), end_date: Time.parse(end_date), advisor_id: advisor_id).first_or_create
        notice_msg = 'Apppointments were successfully created!'

      end
      flash.alert = notice_msg
    end


    respond_to do |format|
      format.html { redirect_to action: "index", notice: notice_msg, status: 200}
      format.json
    end
  end

  def save_all
    @appointments = JSON.parse(params[:appointments])

    @appointments.each do |appointment|
      data = appointment.split("|")
      start_date = hf_format_datetime(data[0])
      #localTime = start_date.to_datetime.localtime
      # if localTime.to_s.include? "-0800"
      #   #start_date2 = start_date.gsub(" AM", ":00.000000000 -0800").gsub(" PM", ":00.000000000 -0800")
      #   start_date2 = start_date.to_datetime + 8.hours
      # else
      #   #start_date2 = start_date.gsub(" AM", ":00.000000000 -0700").gsub(" PM", ":00.000000000 -0700")
      #   start_date2 = start_date.to_datetime + 7.hours
      # end
      end_date = hf_format_datetime(data[1])
      advisor_id = data[2].to_i
      advisor = Advisor.find(advisor_id)
      title = advisor.advisor_type + ' Advisor'

      if data[3] == 'Step1'
        description = 'Academic: Step 1 Advising' + " - " + advisor.name
      elsif data[3] == 'Remed'
        description = 'Academic: Remediation Support' + " - " + advisor.name
      else
        description = data[3] + " Advisor - " + advisor.name
      end

      if !data[4].nil? and data[4].include? "Step Delay"
        description = data[4]
      end

      if Event.exists?(title: title, description: description, start_date: Time.parse(start_date), end_date: Time.parse(end_date), advisor_id: advisor_id)
        @notice_msg = "Found Existing Appointment(s), Not All Appointments were Created!"
      else
        Event.where(title: title, description: description, start_date: Time.parse(start_date), end_date: Time.parse(end_date), advisor_id: advisor_id).first_or_create
        @notice_msg = 'Apppointments were successfully created!'
      end
      flash.alert = @notice_msg
    end

    respond_to do |format|
      format.html {redirect_to action: "index", notice: @notice_msg, status: 200}
      format.json
    end
  end

  def resend_calendar_invite
    Event.fix_event_records
    start_date = Time.now.strftime("%Y/%m/%d")
    @appointments = Event.where("start_date > ? and user_id is not null", start_date).select(:id, :description, :start_date, :end_date, :user_id, :advisor_id, :created_at)
    respond_to do |format|
      format.html
      format.js { render action: 'resend_calendar_invite', status: 200 }
    end
  end

  def resend_invite
    if params[:id].present?
       @meeting = Coaching::Meeting.find_by(event_id: params[:id])
       EventMailer.notify_student(@meeting, "Resend").deliver_later
       @student_name = @meeting.user.full_name
       @student_email = @meeting.user.email
       advisor = Advisor.find_by(id: @meeting.advisor_id)
       @advisor_name = advisor.name
       @advisor_email = advisor.email
     end

     respond_to do |format|
       format.html
     end
  end

  def list_past_valid_appointments
    if params[:start_date].present? and params[:end_date].present?
      @advisor = Advisor.find_by(email: current_user.email)
      start_date = params[:start_date]   #.to_datetime.strftime("%Y/%m/%d")
      end_date = params[:end_date]
      if @advisor.nil?
        @appointments = Event.where("start_date >= ? and end_date <= ? and user_id is not NULL", start_date, end_date).order(:user_id, :start_date)
      else
        @appointments = Event.where("start_date >= ? and end_date <= ? and user_id is not NULL and advisor_id=?", start_date, end_date, @advisor.id).order(:user_id, :start_date)
      end

    end
    respond_to do |format|
      format.html
      format.js { render action: 'display_past_valid_appointments', status: 200 }
    end

  end

  def batch_delete
    @events = nil
    if params[:advisor_id].present?
      if params[:purge].present? and params[:purge] == 'purgeEvent'
        @events = Event.where("advisor_id = ? and start_date < ? and user_id is null", params[:advisor_id], Date.today.strftime("%Y/%m/%d"))
      else
        @events = Event.where(advisor_id: params[:advisor_id], user_id: nil)
      end
    end
    respond_to do |format|
      format.html
      #format.js { render action: 'display_batch_delete', locals: { events: @events }, status: 200 }
    end
  end

  def delete_all
    events = JSON.parse(params[:events])

    if !events.empty?
      events.each do |event_id|
        Event.destroy(event_id.to_i)
      end
      notice_msg = 'Apppointments were successfully deleted!'
    end
    flash.alert = notice_msg
  end

  def get_events_by_advisor

    if params[:advisor_type] == 'Assist Dean'
      @events = Event.where("start_date - INTERVAL '7 hour' > ? and user_id is NULL and (description like 'Assist Dean%' or description like 'Step Delay%')",
        DateTime.now + 17.hours ).order(:start_date)
    elsif params[:advisor_type].include? "Academic"
        if params[:advisor_type].include? "Academic: Step 1" or params[:advisor_type].include? "Academic: Remediation"
          @events = Event.where("start_date - INTERVAL '7 hour' > ? and user_id is NULL and advisor_id is NOT NULL and advisor_id=? and description like ?",
            DateTime.now + 17.hours, params[:advisor_id].to_i,"#{params[:advisor_type]}%" ).order(:start_date)
        else
          @events = Event.where("start_date - INTERVAL '7 hour' > ? and user_id is NULL and advisor_id is NOT NULL and advisor_id=? and description like ?",
            DateTime.now + 17.hours, params[:advisor_id].to_i,"#{params[:advisor_type]} Advisor%" ).order(:start_date)
        end

    else
      @events = Event.where("start_date - INTERVAL '7 hour' > ? and user_id is NULL and advisor_id is NOT NULL and advisor_id=? and description like ?",
        DateTime.now + 17.hours, params[:advisor_id].to_i,"#{params[:advisor_type]}%" ).order(:start_date)
    end

    respond_to do |format|
      format.js { render partial: 'coaching/meetings/get_events', status: 200 }
      format.html
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def set_resources
      @advisor_types = Advisor.where(status: 'Active').pluck(:advisor_type).uniq

      # commented out Step1 Advising on 9/14/2023 - requested by Erika and AA
      # uncommented out Step1 Advising on 12/7/2023 - requested by Erika and AA
      # commented out step 1 advisiing on 4/23/2023 - requested by Erika and Career Advisor
     #@advisor_types.push 'Academic: Step 1 Advising'
     @advisor_types.push 'Academic: Remediation Support'
     @advisor_types.sort!

      @advisors ||= Advisor.where(status: 'Active').select(:id, :name, :email, :advisor_type).order(:name)
      @advisor_name ||= @advisors.map{|n| n.name if n.email==current_user.email}.compact
      advisor_type ||= @advisors.map{|n| n.advisor_type if n.email==current_user.email}.compact

      if @advisor_name.empty?
        @all_advisor_names = @advisors.map{|n| n.name}.compact
      else
        @advisor_types = @advisor_types.map{|a| a if a.include? advisor_type.first}.compact

      end

    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:title, :description, :start_date, :end_date, :user_id, :advisor_id)
    end
end
