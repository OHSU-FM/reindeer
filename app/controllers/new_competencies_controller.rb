class NewCompetenciesController < ApplicationController
  before_action :set_new_competency, only: %i[ show edit update destroy ]

  # GET /new_competencies or /new_competencies.json
  def index
    @new_competencies = NewCompetency.all
  end

  # GET /new_competencies/1 or /new_competencies/1.json
  def show
  end

  # GET /new_competencies/new
  def new
    @new_competency = NewCompetency.new
  end

  # GET /new_competencies/1/edit
  def edit
  end

  # POST /new_competencies or /new_competencies.json
  def create
    @new_competency = NewCompetency.new(new_competency_params)

    respond_to do |format|
      if @new_competency.save
        format.html { redirect_to @new_competency, notice: "New competency was successfully created." }
        format.json { render :show, status: :created, location: @new_competency }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @new_competency.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /new_competencies/1 or /new_competencies/1.json
  def update
    respond_to do |format|
      if @new_competency.update(new_competency_params)
        format.html { redirect_to @new_competency, notice: "New competency was successfully updated." }
        format.json { render :show, status: :ok, location: @new_competency }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @new_competency.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /new_competencies/1 or /new_competencies/1.json
  def destroy
    @new_competency.destroy!

    respond_to do |format|
      format.html { redirect_to new_competencies_path, status: :see_other, notice: "New competency was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_new_competency
      @new_competency = NewCompetency.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def new_competency_params
      params.require(:new_competency).permit(:user_id, :permission_group_id, :student_uid, :email, :medhub_id, :course_name)
    end
end
