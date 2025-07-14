class PrecepMeetingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_precep_meeting, only: %i[ show edit update destroy ]

  # GET /precep_meetings or /precep_meetings.json
  def index
    @precep_meetings = PrecepMeeting.where(user: params[:user_id])
    @user = User.find(params[:user_id])
  end

  # GET /precep_meetings/1 or /precep_meetings/1.json
  def show
  end

  # GET /precep_meetings/new
  def new
    @user = User.find(params[:user_id])
    @precep_meeting = PrecepMeeting.new
    @precep_meeting.user_id = @user.id
    @precep_meeting.student_sid = @user.sid
    @precep_meeting.student_name = @user.full_name
    @precep_meeting.meeting_with = current_user.full_name
    @precep_meeting.other_present = 'None'

  end

  # GET /precep_meetings/1/edit
  def edit
    @user = User.find(params[:user_id])
  end

  # POST /precep_meetings or /precep_meetings.json
  def create
    @precep_meeting = PrecepMeeting.new(precep_meeting_params)

    respond_to do |format|
      if @precep_meeting.save
        format.html { redirect_to @precep_meeting, notice: "Preceptorship meeting was successfully created." }
        format.json { render :show, status: :created, location: @precep_meeting }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @precep_meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /precep_meetings/1 or /precep_meetings/1.json
  def update
    respond_to do |format|
      if @precep_meeting.update(precep_meeting_params)
        format.html { redirect_to @precep_meeting, notice: "Preceptorship meeting was successfully updated." }
        format.json { render :show, status: :ok, location: @precep_meeting }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @precep_meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /precep_meetings/1 or /precep_meetings/1.json
  def destroy
    user_id = @precep_meeting.user_id
    @precep_meeting.destroy!


    respond_to do |format|
      format.html { redirect_to precep_meetings_path(user_id: user_id), status: :see_other, notice: "Preceptorship meeting was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_precep_meeting
      @precep_meeting = PrecepMeeting.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def precep_meeting_params
      params.expect(precep_meeting: [ :user_id, :student_sid, :student_name, :meeting_date, :meeting_notes, :meeting_with, :other_present ])
    end
end
