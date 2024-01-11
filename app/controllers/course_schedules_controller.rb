class CourseSchedulesController < ApplicationController
  layout 'full_width_csl'
  before_action :set_course_schedule, only: %i[ show edit update destroy ]

  # GET /course_schedules or /course_schedules.json
  def index

    if params[:course_id].present?
      @course_schedules = CourseSchedule.where("course_id = ? and start_date > ?", params[:course_id], DateTime.now).select(:id, :course_id, :course_schedule, :start_date, :end_date,
                          :no_of_seats, :comment)
      @course_detail = Course.where(id: params[:course_id]).map(&:attributes)
    end
    respond_to do |format|
      format.html

    end
  end

  # GET /course_schedules/1 or /course_schedules/1.json
  def show
  end

  # GET /course_schedules/new
  def new
    @course_schedule = CourseSchedule.new
  end

  # GET /course_schedules/1/edit
  def edit
  end

  # POST /course_schedules or /course_schedules.json
  def create
    @course_schedule = CourseSchedule.new(course_schedule_params)

    respond_to do |format|
      if @course_schedule.save
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
      params.require(:course_schedule).permit(:course_schedule, :start_date, :end_date, :no_of_seats, :comment)
    end
end
