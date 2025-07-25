class NewCompetenciesController < ApplicationController
  before_action :authenticate_user!, :set_new_competency,  only: %i[ show edit update destroy ]
  before_action :set_resources
  layout 'full_width_csl'
  include NewCompetenciesHelper
  include CompetenciesHelper
  include ArtifactsHelper
  include EpaMastersHelper
  include EpasHelper


  # GET /new_competencies or /new_competencies.json
  def index
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      @new_competencies = NewCompetency.where(user_id: params[:user_id]).order(submit_date: :desc).load_async
      @comp_new = @new_competencies.map(&:attributes)

      @comp_new_hash3 = hf_new_comp(@comp_new, 3)
      @comp_new_data_clinical = hf_average_comp_new (@comp_new_hash3)
      @comp_new_unfiltered = NewCompetency.joins(:user).where(permission_group_id: @user.permission_group_id).load_async.map(&:attributes)
      @comp_class_mean = hf_competency_new_class_mean(@comp_new_unfiltered)
      @chart_new ||= hf_create_chart('New Competency', @comp_new_data_clinical, @comp_class_mean, @user.full_name)

      @mock_artifacts = hf_get_mock(params[:user_id], "Mock Step 1")
      @usmle_exams = UsmleExam.where("user_id=? and exam_type <>'HSS'", params[:user_id]).order(:exam_date, :no_attempts).load_async
      @hss_exams   = UsmleExam.where(user_id: params[:user_id], exam_type: 'HSS').order(:exam_date, :no_attempts).load_async
      @student_badge_info = hf_get_badge_info_new(params[:user_id], @user.new_competency)

      preceptor_assesses = PreceptorAssess.where(user_id: params[:user_id]).load_async.map(&:attributes)
      @preceptor_assesses = hf_collect_values(preceptor_assesses)

      if ["20", "21", "22"].include? @user.permission_group_id.to_s   # only Med26, Med27, Med28
        @wbas = Epa.where(user_id: params[:user_id])
      else
        @wbas = Epa.where("epa <> ? and epa <> ? and user_id = ?", "EPA12", "EPA13", params[:user_id])
      end
      @epas, @epa_hash, @clinical_assessors, @clinical_hash_by_involve, @selected_student, @total_wba_count = hf_get_wbas_new(@wbas)
      @official_docs, @no_official_docs, @shelf_artifacts = hf_get_artifacts(@user.email, "Progress Board")

      if ["20", "21", "22"].include? @user.permission_group_id.to_s  # only Med26, Med27, Med28
        @epa_hash = Epa.where(user_id: params[:user_id]).group(:epa).order(:epa).count
        #re-arranging the EPAs on the graph by using Slice.
        @epa_hash = @epa_hash.slice("EPA1A&1B", "EPA1A", "EPA1B", "EPA2", "EPA3", "EPA4", "EPA5", "EPA6", "EPA7", "EPA8", "EPA9", "EPA10", "EPA11", "EPA12", "EPA13")
        # merge with a epa hash with zero count so that we can show it on graph.
        @epa_hash = epa_hash_merge(@epa_hash, @user.permission_group_id)
      else
        # for Med29, etc..
        @epa_hash = Epa.where("epa <> ? and epa <> ? and user_id = ?", "EPA12", "EPA13", params[:user_id]).group(:epa).order(:epa).count
      end

      @new_epas = hf_new_epa(@comp_new_data_clinical)
      @student_epa ||= @new_epas

      @comp_hash3 = hf_load_all_new_competencies(@comp_new, 3)
      @comp_hash2 = hf_load_all_new_competencies(@comp_new, 2)
      @comp_hash1 = hf_load_all_new_competencies(@comp_new, 1)
      @comp_hash0 = hf_load_all_new_competencies(@comp_new, 0)

      badgingDate = BadgingDate.find_by(permission_group_id: @user.permission_group_id)
      if !badgingDate.nil?
          @release_date = badgingDate.release_date
      else
        @release_date = nil
      end
     @spec_program_msg = @user.spec_program
     @selected_user_year = @user.permission_group.title.split(" ").last.gsub(/[()]/, "")
     @selected_user = @user
     if @selected_user.permission_group_id >= 19  ## greater than Med25
       @formative_feedbacks_qualtrics =  FormativeFeedback.where("user_id=? and csa_code not like ? and response_id like 'R_%' ",
         @selected_user.id, "%Informatics%").order(:submit_date).map(&:attributes)
     else
       @csl_data = hf_get_csl_datasets(@selected_user, 'CSL Narrative Assessment')
     end

     @csl_feedbacks = CslFeedback.where(user_id: @selected_user.id).order(:submit_date).load_async

     if @selected_user.permission_group_id >= 16
       @all_blocks, @all_blocks_class_mean, @category_labels = Competency.all_blocks_mean(@selected_user)
       # if @all_blocks.first.second.empty?  # to check component 1 is empty
       #    @all_blocks, @all_blocks_class_mean, @category_labels =  hf_get_clinical_dataset(@selected_user, 'All Blocks')
       # end

     else
       @all_blocks, @all_blocks_class_mean, @category_labels =  hf_get_clinical_dataset(@selected_user, 'All Blocks')
     end

    end

  end

  # GET /new_competencies/1 or /new_competencies/1.json
  def show
  end

  # GET /new_competencies/new
  def new
    @new_competency = NewCompetency.new
  end

  # GET /new_competencies/1/edit
  def edit
  end

  # POST /new_competencies or /new_competencies.json
  def create
    @new_competency = NewCompetency.new(new_competency_params)

    respond_to do |format|
      if @new_competency.save
        format.html { redirect_to @new_competency, notice: "New competency was successfully created." }
        format.json { render :show, status: :created, location: @new_competency }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @new_competency.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /new_competencies/1 or /new_competencies/1.json
  def update
    respond_to do |format|
      if @new_competency.update(new_competency_params)
        format.html { redirect_to @new_competency, notice: "New competency was successfully updated." }
        format.json { render :show, status: :ok, location: @new_competency }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @new_competency.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /new_competencies/1 or /new_competencies/1.json
  def destroy
    @new_competency.destroy!

    respond_to do |format|
      format.html { redirect_to new_competencies_path, status: :see_other, notice: "New competency was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def competency_rpt
    if params[:permission_group_id].present?
        @cohort_title = PermissionGroup.find(params[:permission_group_id]).title.split(" ").last.gsub(/[()]/, "")
        @cohort_competency = hf_new_comp_by_cohort(params[:permission_group_id],)
        create_file @cohort_competency, "#{@cohort_title}_Detail_Competency.txt"
        respond_to do |format|
          format.html
        end
     end
     render :competency_rpt
  end

  def download_file
      if params[:file_name].present?
        private_download params[:file_name]
        # generic_file_name = params[:file_name]
        # send_file  "#{Rails.root}/tmp/#{generic_file_name}", type: 'text', disposition: 'download'
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_new_competency
      @new_competency = NewCompetency.find(params[:id])
    end

    def set_resources
        @permission_groups = PermissionGroup.where(" id >= ? and id <> ?", 20, 15).order(:id)
    end

    def private_download in_file
      send_file  "#{Rails.root}/tmp/#{in_file}", type: 'text', disposition: 'download'
    end

    # Only allow a list of trusted parameters through.
    def new_competency_params
      params.require(:new_competency).permit(:user_id, :permission_group_id, :student_uid, :email, :medhub_id, :course_name)
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
