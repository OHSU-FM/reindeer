class CourseSchedulesController < ApplicationController
  layout 'full_width_csl'
  before_action :set_course_schedule, only: %i[ show edit update destroy ]

  include CourseSchedulesHelper

  # GET /course_schedules or /course_schedules.json
  def index
    if params[:course_id].present?
      @course_schedules = CourseSchedule.where("course_id = ? and start_date > ? and no_of_seats <> 0 and comment is not null", params[:course_id], DateTime.now - 2.month).order(:start_date)
      @course_detail = Course.where(id: params[:course_id]).map(&:attributes)
    elsif session[:course_id].present?
      @course_schedules = temp_schedules = CourseSchedule.where("course_id = ? and start_date > ? and no_of_seats <> 0 and comment is not null", session[:course_id], DateTime.now - 2.month).order(:start_date)
      @course_detail = Course.where(id: session[:course_id]).map(&:attributes)
    end
    if  @course_schedules.select{|s| s if s.no_of_seats == 777}.count > 0
      @long_course_schedules = hf_process_4_week_schedule(@course_schedules)
      @course_schedules = CourseSchedule.where("course_id = ? and start_date > ? and no_of_seats <> 0 and comment is not null", params[:course_id], DateTime.now - 2.month).order(:start_date)
    end

    respond_to do |format|
      format.html

    end
  end

  # GET /course_schedules/1 or /course_scheedu
  # GET /course_schedules/1.json
  def show
  end

  # GET /course_schedules/new
  def new
    @course_schedule = CourseSchedule.new
    @course_schedule.course_id = params[:course_id]

  end

  # GET /course_schedules/1/edit
  def edit
    #@course_schedule = CourseSchedule.find(params[:id])
  end

  # POST /course_schedules or /course_schedules.json
  def create
    @course_schedule = CourseSchedule.new(course_schedule_params)
    @course_schedule.start_date = params[:start_date]
    @course_schedule.end_date   = params[:end_date]


    respond_to do |format|
      if @course_schedule.save
        session[:course_id] = @course_schedule.course_id
        format.html { redirect_to course_schedule_url(@course_schedule), notice: "Course schedule was successfully created." }
        format.json { render :show, status: :created, location: @course_schedule }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_schedules/1 or /course_schedules/1.json
  def update
    respond_to do |format|
      if @course_schedule.update(course_schedule_params)
        session[:course_id] = @course_schedule.course_id
        format.html { redirect_to course_schedule_url(@course_schedule), notice: "Course schedule was successfully updated." }
        format.json { render :show, status: :ok, location: @course_schedule }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_schedules/1 or /course_schedules/1.json
  def destroy
    session[:course_id] = @course_schedule.course_id
    @course_schedule.destroy!

    respond_to do |format|
      format.html { redirect_to course_schedules_url, notice: "Course schedule was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_schedule
      @course_schedule = CourseSchedule.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_schedule_params
      params.require(:course_schedule).permit(:course_id, :year, :block, :start_date, :end_date, :no_of_seats, :comment)
    end
end
