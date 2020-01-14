class EpaMastersController < ApplicationController
  before_action :set_epa_master, only: [:show, :edit, :update, :destroy]

  # GET /epa_masters
  def index
    @epa_masters = EpaMaster.all
  end

  # GET /epa_masters/1
  def show
  end

  # GET /epa_masters/new
  def new
    @epa_master = EpaMaster.new
  end

  # GET /epa_masters/1/edit
  def edit
  end

  # POST /epa_masters
  def create
    @epa_master = EpaMaster.new(epa_master_params)

    if @epa_master.save
      redirect_to @epa_master, notice: 'Epa master was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /epa_masters/1
  def update
    if @epa_master.update(epa_master_params)
      redirect_to @epa_master, notice: 'Epa master was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /epa_masters/1
  def destroy
    @epa_master.destroy
    redirect_to epa_masters_url, notice: 'Epa master was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_epa_master
      @epa_master = EpaMaster.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def epa_master_params
      params.fetch(:epa_master, {})
    end
end
