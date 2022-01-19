class EpaMastersController < ApplicationController
  layout 'full_width_csl'
  before_action :authenticate_user!
  before_action :set_epa_master, only: [:show, :edit, :update, :destroy]
  before_action :load_eg_cohorts, :set_resources
  include EpaMastersHelper
  include CompetenciesHelper

  # GET /epa_masters
  def index

    if params[:uniq_cohort].present? and params[:uniq_cohort] == 'CaseStudies'
      @eg_cohorts = @all_cohorts.select{|eg| eg if eg["cohort"] == params[:uniq_cohort] }
    elsif
      @eg_cohorts = @all_cohorts.select{|eg| eg if eg["cohort"] == params[:uniq_cohort] and (eg["eg_email1"] == current_user.email or eg["eg_email2"] == current_user.email)}
      EpaMaster.update_not_yet_and_grounded_epas(params[:uniq_cohort])
    end
    if params[:email].present?
      @user = User.find_by(email: params[:email])
      load_epa_masters
    end

  end

  def load_epa_masters
    @epa_masters = @user.epa_masters.order(:id)
    @full_name = @user.full_name
    if @epa_masters.empty?
      create_epas @user.id, @user.email
      @epa_masters = EpaMaster.where(user_id: @user.id).order(:id)
    end

    respond_to do |format|
      format.html
      format.js { render partial: 'search-results' and return}
    end
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
      #redirect_to @epa_master, notice: 'Epa master was successfully updated.'
      @selected_user_id = @epa_master.user_id
      index
    else
      render :edit
    end
  end

  # DELETE /epa_masters/1
  def destroy
    @epa_master.destroy
    redirect_to epa_masters_url, notice: 'Epa master was successfully destroyed.'
  end

  def epa_qa
    if params[:cohort].present?
        @epa_qa_data = hf_process_cohort(params[:cohort], "EPA")
        create_file @epa_qa_data, "epa_qa.txt"
        respond_to do |format|
          format.html
        end
     end
     render :epa_qa
  end

  def wba_epa
    if params[:cohort].present?
        @wba_epa_data = hf_process_cohort(params[:cohort], "WBA")
        @wba_epa_data = @wba_epa_data.sort_by{ |wba| wba["TotalCount"] }.reverse
        create_file @wba_epa_data, "wba_epa.txt"
        respond_to do |format|
          format.html
        end
     end
     render :wba_epa
  end

  def wba_clinical  #get clinical assessor data/count
    if params[:cohort].present?
        @wba_clinical_data = hf_process_cohort(params[:cohort], "ClinicalAssessor")
        create_file @wba_clinical_data, "wba_clinical_assessor.txt"
        respond_to do |format|
          format.html
        end
     end
     render :wba_clinical
  end


  def download_file
      if params[:file_name].present?
        send_file  "#{Rails.root}/tmp/#{params[:file_name]}", type: 'text', disposition: 'download'
      end
  end

  def eg_mismatch
    if params[:cohort].present? and params[:eg_member].present?
      @epa_masters = EpaMaster.get_epa_mismatch params[:cohort], params[:eg_member]
      if !@epa_masters.empty?
        create_file @epa_masters, "eg_mismatch.txt"
      else
        @epa_masters = "No Mismatch Record Found!"
      end
    else
       #flash.now[:alert] = "Please Sekect a Cohort!"
    end
    respond_to do |format|
      format.html
    end
    render :eg_mismatch

  end

  def eg_badged
    if params[:cohort].present?
      epa_badged = EpaMaster.get_epa_badged params[:cohort]
      @epa_badged_count, @student_epa_count = EpaMaster.process_epa_badged epa_badged
    end
    respond_to do |format|
      format.html
    end
    render :eg_badged
  end

  def search_student
    if params[:search]
      @selected_user = nil
      @users = User.where("full_name LIKE ? and coaching_type = ? ", "%#{params[:search]}%", "student")
      if !@users.empty?
        @epa_masters = @users.first.epa_masters.order(:id)
        @full_name = @users.first.full_name
        if @epa_masters.empty?
          user_id = @users.first.id
          create_epas user_id
          @epa_masters = EpaMaster.where(user_id: user_id).order(:id)
        end
      end
      respond_to do |format|
        format.js { render partial: 'search-results'}
      end
    end
  end

  def create_epas selected_user_id, email
    eg_full_name1, eg_full_name2 = hf_get_eg_members(@eg_cohorts, email)

    for i in 1..13 do
      epa_master = EpaMaster.where(user_id: selected_user_id, epa: "EPA#{i}").first_or_create do |epa|
        epa.user_id = selected_user_id
        epa.status = 'Not Yet'
        epa.epa = "EPA#{i}"
      end
      epa_master.epa_reviews.where(epa: epa_master.epa).first_or_create do |review|
        review.epa = epa_master.epa
        review.review_date1 = DateTime.now
        review.review_date2 = DateTime.now
        review.badge_decision1 = "Not Yet"
        review.badge_decision2 = "Not Yet"
        review.trust1 = 'No Decision'
        review.trust2 = 'No Decision'
        review.reason1 ='Have not met the minimum requirements'
        review.reason2 ='Have not met the minimum requirements'
        review.student_comments1 = 'You are making progress towards completing this EPA - continue to look for experiences.'
        review.student_comments2 = 'You are making progress towards completing this EPA - continue to look for experiences.'
        review.reviewer1 = eg_full_name1
        review.reviewer2 = eg_full_name2
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_resources
      @permission_groups = PermissionGroup.where(" id >= ? and id <> ?", 13, 15)
    end

    def set_epa_master
      @epa_master = EpaMaster.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def epa_master_params
      params.require(:epa_master).permit(:user_id, :epa,
        :status, :status_date, :expiration_date )
    end

    def load_eg_cohorts
      @all_cohorts ||= hf_load_eg_cohorts

      @uniq_cohorts ||= @all_cohorts.map{|eg| eg["cohort"]}.uniq
      @uniq_eg_members ||= @all_cohorts.map{|c| [c["eg_full_name1"], c["eg_full_name2"]]}.flatten.uniq.compact.sort
      @uniq_eg_members = ["All"] + @uniq_eg_members
    end

    def create_file (in_data, in_file)
      file_name = "#{Rails.root}/tmp/#{in_file}"

      CSV.open(file_name,'wb', col_sep: "\t") do |csvfile|
        csvfile << in_data.first.keys.map{|c| c.titleize}
        in_data.each do |row|
          csvfile << row.values
        end
      end
    end


end
