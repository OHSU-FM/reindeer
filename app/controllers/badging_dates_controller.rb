class BadgingDatesController < ApplicationController
  before_action :set_badging_date, only: %i[ show edit update destroy ]

  # GET /badging_dates or /badging_dates.json
  def index
    @badging_dates = BadgingDate.all
  end

  # GET /badging_dates/1 or /badging_dates/1.json
  def show
  end

  # GET /badging_dates/new
  def new
    @badging_date = BadgingDate.new
  end

  # GET /badging_dates/1/edit
  def edit
  end

  # POST /badging_dates or /badging_dates.json
  def create
    @badging_date = BadgingDate.new(badging_date_params)

    respond_to do |format|
      if @badging_date.save
        format.html { redirect_to badging_date_url(@badging_date), notice: "Badging date was successfully created." }
        format.json { render :show, status: :created, location: @badging_date }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @badging_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /badging_dates/1 or /badging_dates/1.json
  def update
    respond_to do |format|
      if @badging_date.update(badging_date_params)
        format.html { redirect_to badging_date_url(@badging_date), notice: "Badging date was successfully updated." }
        format.json { render :show, status: :ok, location: @badging_date }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @badging_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /badging_dates/1 or /badging_dates/1.json
  def destroy
    @badging_date.destroy!

    respond_to do |format|
      format.html { redirect_to badging_dates_url, notice: "Badging date was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_badging_date
      @badging_date = BadgingDate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def badging_date_params
      params.require(:badging_date).permit(:permission_group_id, :release_date, :last_review_end_date, :next_review_end_date)
    end
end
