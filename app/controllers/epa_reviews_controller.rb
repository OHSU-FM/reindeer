class EpaReviewsController < ApplicationController
  before_action :set_epa_review, only: [:show, :edit, :update, :destroy]

  # GET /epa_reviews
  def index
    @epa_reviews = EpaReview.all
  end

  # GET /epa_reviews/1
  def show
  end

  # GET /epa_reviews/new
  def new
    @epa_review = EpaReview.new
  end

  # GET /epa_reviews/1/edit
  def edit
  end

  # POST /epa_reviews
  def create
    @epa_review = EpaReview.new(epa_review_params)

    if @epa_review.save
      redirect_to @epa_review, notice: 'Epa review was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /epa_reviews/1
  def update
    if @epa_review.update(epa_review_params)
      redirect_to @epa_review, notice: 'Epa review was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /epa_reviews/1
  def destroy
    @epa_review.destroy
    redirect_to epa_reviews_url, notice: 'Epa review was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_epa_review
      @epa_review = EpaReview.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def epa_review_params
      params.fetch(:epa_review, {})
    end
end
