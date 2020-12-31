class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]


  include EventsHelper

  # GET /events
  # GET /events.json
  def index
    #@events = Event.where('start_date > ?', DateTime.now)
    @events = Event.all.order(start_date: :desc).paginate(:page => params[:page], :per_page => 10)
    @events.each do |event|
      full_name = hf_full_name (event.id)
      if !full_name.empty?
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

  def create_batch_appointments
    @advisors = Advisor.all
    if params[:advisor_type].present?
      @advisor_type = params[:advisor_type]
      @advisor = params[:advisor]
      @appointments = Event.enumerate_hours(params[:start_date], params[:end_date])
      respond_to do |format|
        #format.html
        format.js { render action: 'display_batch_appointments', status: 200 }
      end
      #Time.at(@appointments.first).utc.strftime("%m/%d/%Y %T %p")

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
      Event.create(title: title, description: description, start_date: start_date, end_date: end_date)

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

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:title, :description, :start_date, :end_date)
    end
end
