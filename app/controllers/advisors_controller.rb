class AdvisorsController < ApplicationController
  before_action :set_advisor, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json, :js
  # GET /advisors
  # GET /advisors.json
  def index
    @advisors = Advisor.all.sort_by(&:name)
  end

  # GET /advisors/1
  # GET /advisors/1.json
  def show
  end

  # GET /advisors/new
  def new
    @advisor = Advisor.new
  end

  # GET /advisors/1/edit
  def edit
  end

  # POST /advisors
  # POST /advisors.json
  def create
    @advisor = Advisor.new(advisor_params)

    respond_to do |format|
      if @advisor.save
        format.html { redirect_to @advisor, notice: 'Advisor was successfully created.' }
        format.json { render :show, status: :created, location: @advisor }
      else
        format.html { render :new }
        format.json { render json: @advisor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /advisors/1
  # PATCH/PUT /advisors/1.json
  def update
    respond_to do |format|
      if @advisor.update(advisor_params)
        format.html { redirect_to @advisor, notice: 'Advisor was successfully updated.' }
        format.json { render :show, status: :ok, location: @advisor }
      else
        format.html { render :edit }
        format.json { render json: @advisor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /advisors/1
  # DELETE /advisors/1.json
  def destroy
    @advisor.destroy
    respond_to do |format|
      format.html { redirect_to advisors_url, notice: 'Advisor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advisor
      @advisor = Advisor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def advisor_params
      params.require(:advisor).permit(:advisor_type, :name, :email, :status, :title, :specialty)
    end
end
