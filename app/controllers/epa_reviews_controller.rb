class EpaReviewsController < ApplicationController
  before_action :authenticate_user!, :find_reviewable, :load_reasons #, :load_eg_members

  include CompetenciesHelper
  include NewCompetenciesHelper
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

  def local_storage
    if params[:epa_json].present?
      email = params[:epa_json]["0"]["email"]
      user = User.find_by(email: email)

      #load_eg_members(user)

      EpaReview.load_epa(params[:epa_json], @eg_full_name1, @eg_full_name2)
    end

    respond_to do |format|
      format.json #{ head :no_content }
      #format.js { render action: 'Updated EPAs!', status: 200 }
    end
  end

  # GET /epa_reviews/new
  def new
    @epa_review = @reviewable.epa_reviews.new
    @epa_master = EpaMaster.find_by_id(params[:epa_master_id])
    @user_id = @epa_master.user_id
    @epa_review.epa = @epa_master.epa
    @epa_review_epa = @epa_review.epa

    @decision_option = ["Grounded", "Presumptive", "Distrust", "Questioned Trust", "No Decision"]
    @decision_option2 = @decision_option

    #@epa_count = EpaMaster.where(user_id: @user_id).count  # if the count is 12 -> new epas, count=13 -> old epas
    if EpaMaster.where(user_id: @user_id, epa: "EPA1A").any?
      @epa_count = 12 ## new epas
    else
      @epa_count = 13  ## old epas
    end
    @new_competency = User.find(@user_id).new_competency

    get_evidence @user_id, @epa_count

    if !current_user.admin_or_higher? then
      @eg_members = [current_user.full_name]
    end

    @epa_review.reviewer1 = @eg_full_name1.first
    @epa_review.reviewer2 = @eg_full_name2.first
    @epa_review.reason1 = @eg_reasons.second
    @epa_review.reason2 = @eg_reasons.second
    @epa_review.badge_decision1 = 'Not Yet'
    @epa_review.badge_decision2 = 'Not Yet'
    @epa_review.trust1 = 'No Decision'
    @epa_review.trust2 = 'No Decision'
    @epa_review.student_comments1 = 'You are making progress towards completing this EPA - continue to look for experiences.'
    @epa_review.student_comments2 = 'You are making progress towards completing this EPA - continue to look for experiences.'

    epa_idx = @epa_review_epa.downcase
    # str_complete = "QA Completion %: " +  @percent_complete[epa_idx].to_s + "\r"  +
    #                "Total No of WBA: " + @wba["#{@epa_review_epa}"].sum.to_s + "\r".html_safe
     str_complete = "QA Completion: " +  @percent_complete[@epa_review_epa.downcase].to_s + "\r"  +
              "Total No of WBA: " + @wba["#{@epa_review_epa}"].sum.to_s +  "\r".html_safe

    str_wba = hf_wba_str(@wba["#{@epa_review_epa}"])
    @epa_review.evidence1 = str_complete + str_wba
    @epa_review.evidence2 = str_complete + str_wba

    respond_to do |format|
      format.html
      format.js {render template: 'epa_reviews/epa_reviews_modal'}
    end

    #return
  end

  # GET /epa_reviews/1/edit
  def edit
    @epa_review = EpaReview.find(params[:id])
    @decision_option = ["Grounded", "Presumptive", "Distrust", "Questioned Trust", "No Decision"]
    @decision_option2 = ["Grounded", "Presumptive", "Distrust", "Questioned Trust", "No Decision"]
    # if @epa_review.badge_decision2 == 'Not Yet'
    #   @decision_option2 = []
    # elsif @epa_review.badge_decision2 == 'Badge'
    #   @decision_option2 = ["Grounded", "Presumptive"]
    # else
    #   @decision_option2 = ["Distrust", "Questioned Trust"]
    # end

    @epa_review_epa = @epa_review.epa

    @user_id = EpaMaster.find(@epa_review.reviewable_id).user_id

    #@epa_count = EpaMaster.where(user_id: @user_id).count  # if the count is 12 -> new epas, count=13 -> old epas
    if EpaMaster.where(user_id: @user_id, epa: "EPA1A").any?
      @epa_count = 12 ## new epas
    else
      @epa_count = 13  ## old epas
    end
    @new_competency = User.find(@user_id).new_competency

    get_evidence(@user_id, @epa_count)
    epa_idx = @epa_review_epa.split("EPA").second
    # str_complete = "QA Completion %: " +  @percent_complete[@epa_review_epa.downcase].to_s + "\r"  +
    #                "Total No of WBA: " + @wba["#{@epa_review_epa}"].sum.to_s + "\r".html_safe

   str_complete = "QA Completion: " +  @percent_complete[@epa_review_epa.downcase].to_s + "\r"  +
            "Total No of WBA: " + @wba["#{@epa_review_epa}"].sum.to_s +  "\r".html_safe


    str_wba = hf_wba_str(@wba["#{@epa_review_epa}"])

    @epa_review.evidence1 = str_complete + str_wba # commented this out as we want to grap & replace the new data --> if @epa_review.evidence1.blank?
    @epa_review.evidence2 = str_complete + str_wba # commented this out as we want to grap & replace the new data --> if @epa_review.evidence2.blank?

    @epa_review.reviewer1 = @eg_full_name1 if @epa_review.reviewer1.blank?
    @epa_review.reviewer2 = @eg_full_name2 if @epa_review.reviewer2.blank?
    respond_to do |format|
      format.html
      format.js {render template: 'epa_reviews/epa_reviews_modal'}
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

  def get_evidence (user_id, epa_count)
    @user ||= User.find(user_id)

    if @user.new_competency #epa_count == 12 # new epas
      @comp = NewCompetency.where(user_id: @user.id).order(submit_date: :desc)
    else
      @comp = Competency.where(user_id: @user.id).order(submit_date: :desc)
    end

    if @comp.empty?
      @clinical_data ||= hf_get_clinical_dataset(@user, 'Clinical')
      epa_percent_complete ||= hf_epa_class_mean(@clinical_data)
      @percent_complete = {}
      i = 1
      epa_percent_complete.drop(1).each do |epa_val|  ## skip the first item as ti contains the ave. EPA
        @percent_complete.store("epa#{i}", epa_val)
        i += 1
      end

      ## for OMFS students, they have no core courses
      if @percent_complete.uniq.first == 0
        @percent_complete = EpaReview.epa_init
      end
    else
      @comp = @comp.map(&:attributes)
      # commented out for new competencies
      if @user.new_competency
        @comp_hash3 = hf_load_all_new_competencies(@comp, 3)
        @comp = hf_hightlight_all_epas(@comp, @user.new_competency)
        @comp_data_clinical = hf_average_comp_new (@comp_hash3)
        @percent_complete ||= hf_new_epa(@comp_data_clinical)
      else
        @comp_hash3 = hf_load_all_comp2(@comp, 3)
        @comp = hf_hightlight_all_epas(@comp, @user.new_competency)
        @comp_data_clinical = hf_average_comp2 (@comp_hash3)
        @percent_complete ||= hf_epa2(@comp_data_clinical)
      end
    end

    #@student_badge_info = hf_get_badge_info(@user.id)
    @preceptorship_data  = hf_get_preceptor_assesses_data(@user)
    if @user.new_competency   #epa_count == 12 # new epas
      @wba ||= hf_get_wbas_involvement(@user.id)
    else
      @wba ||= hf_get_old_wbas_involvement(@user.id)
    end

    @csl_data ||= hf_get_csl_datasets(@user, 'CSL Narrative Assessment')
    if @csl_data.empty?
      @csl_feedbacks = CslFeedback.where(user_id: @user.id).order(:submit_date)
      @csl_data = []
      @formative_feedbacks_qualtrics =  FormativeFeedback.where("user_id=? and csa_code not like ? and response_id like 'R_%' ",
        @user.id, "%Informatics%").order(:submit_date).map(&:attributes)

    end
    @artifacts_student, @no_official_docs, @shelf_artifacts = hf_get_artifacts(@user.email, "Progress Board")
    @today_date = Time.new.strftime("%m/%d/%Y")
    #load_eg_members(@user)
    @bls = @user.ume_bls

    badgingDates = BadgingDate.find_by(permission_group_id: @user.permission_group_id)
    @lastReviewEndDate = badgingDates.last_review_end_date
    @nextReviewEndDate = badgingDates.next_review_end_date

    if current_user.spec_program == 'AccessAI'
      get_ai_data
    end

    #@eval_ai_content2 = @eval_ai_content2.gsub("|", "\t")

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

     # def load_eg_members(user)
     #   @eg_members, @eg_full_name1, @eg_full_name2 = EpaReview.load_eg_members(user)
     # end

     def load_reasons
       @eg_reasons ||= EgReason.all.select(:reason).to_a.map{|r| r.reason}
     end

     # def load_review_dates
     #       @badge_review_dates ||= YAML.load_file("config/badgeReleaseDate.yml")
     #
     # end

     def get_ai_data
       file_name = "#{Rails.root}/public/epa_reviews/google_ai_data/#{@user.full_name}_ai.txt"
       if File.exist?(file_name) && current_user.spec_program == 'AccessAI'
         @eval_ai_content = File.read(file_name)
         @eval_ai_content = @eval_ai_content.gsub("\n", "<br />").gsub("**Disclaimer:**", "<b>**Disclaimer:**</b>").gsub("Evidence:", "<b>Evidence: </b>")
         @eval_ai_content = @eval_ai_content.gsub("FileName", "<h5 style='color:blue;'>FileName").gsub("AI Responses:", "AI Responses: </h5><p style='font-family:Courier'")
         @eval_ai_content += '</p>'
       else
         @eval_ai_content = 'No AI Eval Found!'
       end


       file_name = "#{Rails.root}/public/epa_reviews/chatgpt_ai_data/#{@user.full_name}_ai.txt"
       if File.exist?(file_name) && current_user.spec_program == 'AccessAI'
         @eval_ai_content2 = File.read(file_name)
         @eval_ai_content2 = @eval_ai_content2.gsub("\n", "<br />").gsub("**Disclaimer:**", "<b>**Disclaimer:**</b>").gsub("Evidence:", "<b>Evidence: </b>")
         @eval_ai_content2 = @eval_ai_content2.gsub("FileName", "<h5 style='color:purple;'>FileName").gsub("AI Responses:", "AI Responses: </h5>")

       else
         @eval_ai_content2 = 'No AI Eval Found!'
       end
     end

end
