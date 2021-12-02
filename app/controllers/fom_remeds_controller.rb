class FomRemedsController < ApplicationController
  before_action :set_fom_remed, only: %i[ show edit update destroy ]

  # GET /fom_remeds or /fom_remeds.json
  def index
    @fom_remeds = FomRemed.all
  end

  # GET /fom_remeds/1 or /fom_remeds/1.json
  def show
  end

  # GET /fom_remeds/new
  def new
    @fom_remed = FomRemed.new
  end

  # GET /fom_remeds/1/edit
  def edit
  end

  # POST /fom_remeds or /fom_remeds.json
  def create
    @fom_remed = FomRemed.new(fom_remed_params)

    respond_to do |format|
      if @fom_remed.save
        format.html { redirect_to @fom_remed, notice: "Fom remed was successfully created." }
        format.json { render :show, status: :created, location: @fom_remed }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fom_remed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fom_remeds/1 or /fom_remeds/1.json
  def update
    respond_to do |format|
      if @fom_remed.update(fom_remed_params)
        format.html { redirect_to @fom_remed, notice: "Fom remed was successfully updated." }
        format.json { render :show, status: :ok, location: @fom_remed }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fom_remed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fom_remeds/1 or /fom_remeds/1.json
  def destroy
    @fom_remed.destroy
    respond_to do |format|
      format.html { redirect_to fom_remeds_url, notice: "Fom remed was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fom_remed
      @fom_remed = FomRemed.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def fom_remed_params
      params.require(:fom_remed).permit(:user_id, :block)
    end
end
