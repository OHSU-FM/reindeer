class EpasController < ApplicationController
  before_action :set_epa, only: [:show, :edit, :update, :destroy]

  # GET /epas
  def index
    if !@pk.nil?
      selected_user = User.where(email: @pk)
      @epas = Epa.where(user_id: selected_user.id).order(:epa, :submit_date)
    else
      @epas = Epa.where(user_id: current_user.id).order(:epa, :submit_date)
    end
  end

  # GET /epas/1
  def show
  end

  # GET /epas/new
  def new
    @epa = Epa.new
  end

  # GET /epas/1/edit
  def edit
  end

  # POST /epas
  def create
    @epa = Epa.new(epa_params)

    if @epa.save
      redirect_to @epa, notice: 'Epa was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /epas/1
  def update
    if @epa.update(epa_params)
      redirect_to @epa, notice: 'Epa was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /epas/1
  def destroy
    @epa.destroy
    redirect_to epas_url, notice: 'Epa was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_epa
      @epa = Epa.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def epa_params
      params.require(:epa).permit(:submit_date, :student_assessed, :epa, :clinical_discipline, :clinical_setting, :clincial_assessor)
    end
end
