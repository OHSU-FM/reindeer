class EpaReviewsController < ApplicationController
  before_action :authenticate_user!, :find_reviewable, :load_reasons   #, :load_eg_members

  include CompetenciesHelper
  include ArtifactsHelper
  include WbaGraphsHelper
  include EpasHelper
  include EpaReviewsHelper
  include EpaMastersHelper
  include LsReports::CslevalHelper
  include LsReports::ClinicalphaseHelper

  # GET /epa_reviews
  def index
    @epa_reviews  = EpaReview.find_by(epa_masters_id: params[:epa_masters_id])
  end

  # GET /epa_reviews/1
  def show
  end

  # GET /epa_reviews/new
  def new
    @epa_review = @reviewable.epa_reviews.new
    @epa_master = EpaMaster.find_by_id(params[:epa_master_id])
    @user_id = @epa_master.user_id
    @epa_review.epa = @epa_master.epa
    @epa_review_epa = @epa_review.epa

    @decision_option = ["Grounded", "Presumptive"]
    @decision_option2 = @decision_option
    get_evidence @user_id

    if !current_user.admin_or_higher? then
      @eg_members = [current_user.full_name]
    end

    epa_idx = @epa_review_epa.split("EPA").second.to_i
    str_complete = "QA Completion %: " +  @percent_complete[epa_idx].to_s + "\r"  +
                   "Total No of WBA: " + @wba["#{@epa_review_epa}"].sum.to_s + "\r".html_safe
    str_wba = hf_wba_str(@wba["#{@epa_review_epa}"])
    @epa_review.evidence1 = str_complete + str_wba
    @epa_review.evidence2 = str_complete + str_wba

    respond_to do |format|
      format.html
      format.js {render template: 'epa_reviews/epa_reviews_modal.js.erb'}
    end

    #return
  end

  # GET /epa_reviews/1/edit
  def edit
    @epa_review = EpaReview.find(params[:id])
    if @epa_review.badge_decision1 == 'Not Yet'
      @decision_option = []
    elsif @epa_review.badge_decision1 == 'Badge'
      @decision_option = ["Grounded", "Presumptive"]
    else
      @decision_option = ["Distrust", "Questioned Trust"]
    end

    if @epa_review.badge_decision2 == 'Not Yet'
      @decision_option2 = []
    elsif @epa_review.badge_decision2 == 'Badge'
      @decision_option2 = ["Grounded", "Presumptive"]
    else
      @decision_option2 = ["Distrust", "Questioned Trust"]
    end

    @epa_review_epa = @epa_review.epa

    @user_id = EpaMaster.find(@epa_review.reviewable_id).user_id

    get_evidence @user_id
    epa_idx = @epa_review_epa.split("EPA").second.to_i
    str_complete = "QA Completion %: " +  @percent_complete[epa_idx].to_s + "\r"  +
                   "Total No of WBA: " + @wba["#{@epa_review_epa}"].sum.to_s + "\r".html_safe
    str_wba = hf_wba_str(@wba["#{@epa_review_epa}"])

    @epa_review.evidence1 = str_complete + str_wba if @epa_review.evidence1.blank?
    @epa_review.evidence2 = str_complete + str_wba if @epa_review.evidence2.blank?

    respond_to do |format|
      format.html
      format.js {render template: 'epa_reviews/epa_reviews_modal.js.erb'}
    end

  end

  # POST /epa_reviews
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

    @user_id = EpaReview.update_epa_master(@epa_review.reviewable_id, @epa_review.epa, @epa_review.badge_decision1, @epa_review.badge_decision2)
  end

  # PATCH/PUT /epa_reviews/1
  def update
    @epa_review = EpaReview.find(params[:id])
    respond_to do |format|
      if @epa_review.update(epa_review_params)
        format.html { redirect_to epa_masters_path }
        # format.html { redirect_to @epa_review, notice: 'Epa review was successfully updated.'}
        # format.json { render :show, status: :ok, location: @epa_review }

      else
        format.html { render :edit }
        format.json { render json: @epa_review.errors, status: :unprocessable_entity }
      end
    end
    EpaReview.update_epa_master(@epa_review.reviewable_id, @epa_review.epa, @epa_review.badge_decision1, @epa_review.badge_decision2)
  end

  # DELETE /epa_reviews/1
  def destroy
    @epa_review = EpaReview.find(params[:id])
    @epa_review.destroy
    respond_to do |format|
      format.html { redirect_to epa_reviews_url, notice: 'Epa review was successfully destroyed.' }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  def get_evidence (user_id)
    @user ||= User.find(user_id)

    if (@comp = Competency.where(user_id: @user.id).order(:submit_date)).empty?
      @clinical_data ||= hf_get_clinical_dataset(@user, 'Clinical')
      @percent_complete ||= hf_epa_class_mean(@clinical_data)
    else
      @comp = @comp.map(&:attributes)
      @comp_hash3 = hf_load_all_comp2(@comp, 3)
      @comp_hash2 = hf_load_all_comp2(@comp, 2)
      @comp_hash1 = hf_load_all_comp2(@comp, 1)

      @comp_data_clinical = hf_average_comp2 (@comp_hash3)
      @student_epa ||= hf_epa2(@comp_data_clinical)
      @percent_complete = @student_epa

    end

    @student_badge_info = hf_get_badge_info(@user.id)

    @preceptorship_data ||= hf_get_clinical_dataset(@user, 'Preceptorship')
    @wba ||= hf_get_wbas(@user.id)

    @csl_data ||= hf_get_csl_datasets(@user, 'CSL Narrative Assessment')
    if @csl_data.empty?
      @csl_feedbacks = CslFeedback.where(user_id: @user.id).order(:submit_date)
      @csl_data = []
    end
    @artifacts_student, @no_official_docs, @shelf_artifacts = hf_get_artifacts(@user.email, "Progress Board")
    @today_date = Time.new.strftime("%m/%d/%Y")
    load_eg_members(@user)

    ## getting WPAs
     @epas, @epa_hash, @epa_evaluators, @unique_evaluators, @selected_dates, @selected_student, @total_wba_count = hf_get_epas(@user.email)
     if !@epas.blank?
       gon.epa_adhoc = @epa_hash #@epa_adhoc
       gon.epa_evaluators = @epa_evaluators
       gon.unique_evaluators = @unique_evaluators
       gon.selected_dates = @selected_dates
       gon.selected_student = @selected_student
       gon.total_wba_count = @total_wba_count
     end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_epa_review
      @epa_review = EpaReview.find(params[:id])
    end

     # Never trust parameters from the scary internet, only allow the white list through.
     def epa_review_params
       params.require(:epa_review).permit(:epa, :review_date1, :reviewer1,
       :badge_decision1, :reason1, :trust1, :evidence1, :general_comments1,
       :review_date2, :reviewer2, :student_comments1,
       :badge_decision2, :reason2, :trust2, :evidence2, :general_comments2, :student_comments2,
       :reviewable_id, :reviewable_type)
     end

     def find_reviewable
       @reviewable = EpaReview.find_by_id(params[:epa_review_id]) if params[:epa_review_id]
       @reviewable = EpaMaster.find_by_id(params[:epa_master_id]) if params[:epa_master_id]

     end

     def load_eg_members(user)
       @eg_members ||= EpaReview.load_eg_members(user)
     end

     def load_reasons
       @eg_reasons ||= EgReason.all.select(:reason).to_a.map{|r| r.reason}
     end

end
