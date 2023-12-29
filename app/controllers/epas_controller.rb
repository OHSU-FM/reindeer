class EpasController < ApplicationController
  before_action :set_epa, only: [:show, :edit, :update, :destroy]
  layout 'full_width_csl'
  # GET /epas
  def index
    if params[:user_id].present?
      @epas = Epa.where(user_id: params[:user_id].to_i).order(:epa, :submit_date)
      if !@epas.empty?
        @epas = @epas.map(&:attributes)
        @epa_headers = @epas.first.keys
      end 
    end


    respond_to do |format|
      format.html
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
      edirect_to @epa, notice: 'Epa was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /epas/1
  def update
    if @epa.update(epa_params)
      #redirect_to @epa, notice: 'Epa was successfully updated.'
      load_epas (@epa.user_id)
      flash.now[:notice] = "WBA was successfully updated!"
      render :index

    else
      render :edit
    end
  end

  # DELETE /epas/1
  def destroy
    @epa.destroy
    load_epas (@epa.user_id)
    #redirect_to epas_url, notice: 'Epa was successfully destroyed.'
    flash.now[:notice] = "WBA was successfully Deleted!"
    render :index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_epa
      @epa = Epa.find(params[:id])
    end

    def load_epas(user_id)
      @epas = Epa.where(user_id: user_id).order(:epa, :submit_date)
      @epas = @epas.map(&:attributes)
      @epa_headers = @epas.first.keys
    end

    # Only allow a trusted parameter "white list" through.
    def epa_params
      params.require(:epa).permit(:submit_date, :student_assessed, :epa, :clinical_discipline, :clinical_setting, :clinical_assessor,
        :assessor_name, :assessor_email)
    end
end
