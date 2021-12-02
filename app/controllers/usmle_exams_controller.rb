class UsmleExamsController < ApplicationController
  before_action :set_usmle_exam, only: [:show, :edit, :update, :destroy]

  # GET /usmle_exams
  def index
    @usmle_exams = UsmleExam.all
  end

  # GET /usmle_exams/1
  def show
  end

  # GET /usmle_exams/new
  def new
    @usmle_exam = UsmleExam.new
  end

  # GET /usmle_exams/1/edit
  def edit
  end

  # POST /usmle_exams
  def create
    @usmle_exam = UsmleExam.new(usmle_exam_params)

    if @usmle_exam.save
      redirect_to @usmle_exam, notice: 'Usmle exam was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /usmle_exams/1
  def update
    if @usmle_exam.update(usmle_exam_params)
      redirect_to @usmle_exam, notice: 'Usmle exam was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /usmle_exams/1
  def destroy
    @usmle_exam.destroy
    redirect_to usmle_exams_url, notice: 'Usmle exam was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_usmle_exam
      @usmle_exam = UsmleExam.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def usmle_exam_params
      params.require(:usmle_exam).permit(:user.references, :exam_type, :no_attempts, :pass_fail, :exam_score, :exam_date)
    end
end
