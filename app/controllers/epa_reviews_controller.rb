class EpaReviewsController < ApplicationController
  before_action :find_reviewable
  # GET /epa_reviews
  # GET /epa_reviews.json
  def index
    @epa_reviews = EpaReview.find_by(epa_masters_id: params[:epa_masters_id])
  end

  # GET /epa_reviews/1
  # GET /epa_reviews/1.json
  def show
     @epa_review = EpaReview.find(params[:id])
  end

  # GET /epa_reviews/new
  def new
    @epa_review = @reviewable.epa_reviews.new
    @epa_master = EpaMaster.find_by_id(params[:epa_master_id])
    @user_id = @epa_master.user_id
    @epa_review.epa = @epa_master.epa
    @epa_review_epa = @epa_review.epa

    respond_to do |format|
      format.html
      format.js {render template: 'epa_reviews/epa_review_modal.js.erb'}
    end

  end

  # GET /epa_reviews/1/edit
  def edit
    @epa_review = EpaReview.find(params[:id])
    @epa_review_epa = @epa_review.epa
    respond_to do |format|
      format.html
      format.js {render template: 'epa_reviews/epa_review_modal.js.erb'}
    end
  end

  # POST /epa_reviews
  # POST /epa_reviews.json
  def create
    @epa_review = EpaReview.new(epa_review_params)

    respond_to do |format|
      if @epa_review.save
        format.html { redirect_to @epa_review, notice: 'Epa review was successfully created.' }
        format.json { render :show, status: :created, location: @epa_review }
      else
        format.html { render :new }
        format.json { render json: @epa_review.errors, status: :unprocessable_entity }
      end
    end
    @user_id = EpaReview.update_epa_master(@epa_review.reviewable_id, @epa_review.epa, @epa_review.egm_recommendation )

  end

  # PATCH/PUT /epa_reviews/1
  # PATCH/PUT /epa_reviews/1.json
  def update
        @epa_review = EpaReview.find(params[:id])
        respond_to do |format|
          if @epa_review.update(epa_review_params)
            format.html { redirect_to @epa_review, notice: 'Epa review was successfully updated.'}
            format.json { render :show, status: :ok, location: @epa_review }
          else
            format.html { render :edit }
            format.json { render json: @epa_review.errors, status: :unprocessable_entity }
          end
        end
        EpaReview.update_epa_master(@epa_review.reviewable_id, @epa_review.epa, @epa_review.egm_recommendation )


  end

  # DELETE /epa_reviews/1
  # DELETE /epa_reviews/1.json
  def destroy
    @epa_review.destroy
    respond_to do |format|
      format.html { redirect_to epa_reviews_url, notice: 'Epa review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_qualtrics
    if params[:user_id].present?
      username = User.select(:username).find_by_id(params[:user_id]).username
      @get_qualtrics_msg = EpaReview.api_qualtrics(username, params[:user_id])

      respond_to do |format|
        format.html
        format.js {render template: 'epa_reviews/load_qualtrics_modal.js.erb'}
      end
    else
      render :index
    end

  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_epa_review
      @epa_review = EpaReview.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def epa_review_params
      params.require(:epa_review).permit(:epa, :review_date1, :reviewed_by1,
      :egm_recommendation, :general_comments,
       :reviewable_id, :reviewable_type)
    end

    def find_reviewable
      @reviewable = EpaReview.find_by_id(params[:epa_review_id]) if params[:epa_review_id]
      @reviewable = EpaMaster.find_by_id(params[:epa_master_id]) if params[:epa_master_id]
    end
end
