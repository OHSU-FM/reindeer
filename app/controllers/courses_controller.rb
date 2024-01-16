class CoursesController < ApplicationController
  layout 'full_width_csl'
  before_action :authenticate_user!
  before_action :set_resources

  # GET /courses or /courses.json
  def index
    if params[:category].present? and params[:duration].present?
      @courses = Course.where(category: params[:category], duration: params[:duration]).select(:id, :category, :course_number, :course_name, :department, :rural, :continuity, :duration, :credits, :course_purpose_statement).order(:course_number)
      @courses = @courses.map(&:attributes)
    elsif params[:course_name].present?
      if params[:course_name].include? ":"
        query_string = params[:course_name].split(":")
        @courses = Course.where("course_number like ? and course_name like ?", "%#{query_string[0]}%", "%#{query_string[1]}%").
           select(:id, :category, :course_number, :course_name, :department, :rural, :continuity, :duration, :credits, :course_purpose_statement).order(:course_number)
      else
        @courses = Course.where("course_name like ?", "%#{params[:course_name]}%").
           select(:id, :category, :course_number, :course_name, :department, :rural, :continuity, :duration, :credits, :course_purpose_statement).order(:course_number)

      end
      @courses = @courses.map(&:attributes)
    end
  end

  # GET /courses/1 or /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to course_url(@course), notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to course_url(@course), notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy!

    respond_to do |format|
      format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:course_number, :course_name, :content_type, :medhub_course_id, :rural,
        :continuity, :available_through_the_lottery, :department, :course_purpose_statement, :special_notes, :prerequisites,
        :required_prerequisites, :waive_prereq_requirements, :waive_notes, :duration, :site, :weekly_workload, :credits,
        :course_director, :course_director_email, :course_coordinator, :course_coordinator_email, :competencies)
    end

    def set_resources
      @category = Course.all.pluck(:category).uniq
      #@duration = Course.all.pluck(:duration).uniq
      @departments = Course.all.pluck(:department).uniq.sort
      @courses = Course.where(category: 'Cores').
       select(:id, :category, :course_number, :course_name, :department, :rural, :continuity, :duration, :credits, :course_purpose_statement).order(:course_number)
      @courses = @courses.map(&:attributes)

    end
end
