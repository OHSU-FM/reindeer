class EventsController < ApplicationController
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
        full_name = event.user.full_name  #hf_full_name (event.id)
        event.title = event.title + ' - ' + full_name
      end

    end
    respond_to do |format|
      format.json
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
    @advisors = Advisor.where(status: 'Active').order(:name)
    if params[:advisor_type].present?
      @advisor_type = params[:advisor_type]
      @advisor = params[:advisor]
      @time_slot = params[:time_slot]
      session[:advisor_type] = @advisor_type
      session[:advisor] = @advisor
      @appointments = Event.enumerate_hours(params[:start_date], params[:end_date], params[:time_slot])
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
      startDates = params.as_json.to_hash.map{|key, val| val if key.include? "startDate"}.compact  #

      @appointments = Event.reformat_startDate(startDates, @time_slot)
      respond_to do |format|
        #format.html
        format.js { render action: 'display_batch_appointments', status: 200 }
      end
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

  def save_all
    @appointments = JSON.parse(params[:appointments])

    @appointments.each do |appointment|
      data = appointment.split("|")
      title = data[0].split(" - ").first
      description = data[0]
      start_date = hf_format_datetime(data[1].gsub("at ", ""))
      end_date = hf_format_datetime(data[2].gsub("at ", ""))
      advisor_id = data[3].to_i
      Event.create(title: title, description: description, start_date: start_date, end_date: end_date, advisor_id: advisor_id)
    end
    respond_to do |format|
      format.html { redirect_to action: "index", notice: 'Apppointments were successfully created.' }
      format.json
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def set_resources
      @advisor_types = Advisor.where(status: 'Active').pluck(:advisor_type).uniq
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:title, :description, :start_date, :end_date, :user_id, :advisor_id)
    end
end
