class EpaMastersController < ApplicationController
  layout 'full_width_csl'
  #authorize_resource class: EpaMastersController
  before_action :authenticate_user!
  before_action :set_epa_master, only: [:show, :edit, :update, :destroy]
  before_action :load_eg_cohorts, :set_resources
  include EpaMastersHelper
  include EpaReviewsHelper
  include FixEgMembersHelper
  include CompetenciesHelper
  include NewCompetenciesHelper

  # GET /epa_masters
  def index

    if params[:uniq_cohort].present? and (params[:uniq_cohort] == 'CaseStudies' or params[:uniq_cohort] == 'CaseStudies2')
      @eg_cohorts = @all_cohorts.select{|eg| eg if eg["cohort"] == params[:uniq_cohort] }
    elsif params[:uniq_cohort].present?
      #@eg_cohorts = @all_cohorts.select{|eg| eg if eg["permission_group_id"] == params[:uniq_cohort].to_i and (eg["eg_email1"] == current_user.email or eg["eg_email2"] == current_user.email)}
      @eg_cohorts = EpaMaster.get_eg_cohort(params[:uniq_cohort], current_user.email)
      EpaMaster.update_not_yet_and_grounded_epas(params[:uniq_cohort])
    end
    if params[:email].present?
      @user = User.find_by(email: params[:email])
      load_epa_masters
    end

  end

  def load_epa_masters
    #@epa_masters = EpaMaster.where("epa not in ('EPA12', 'EPA13') and user_id=?", @user.id).order(:epa, :id)
    @epa_masters = @user.epa_masters.order(:epa)
    if @epa_masters.first.epa == "EPA10" && @epa_masters.second.epa == "EPA11" && @epa_masters.third.epa == "EPA12"
      @epa_masters = @epa_masters.rotate(3)
    elsif @epa_masters.first.epa == "EPA10" && @epa_masters.second.epa == "EPA11" ## move EPA10 & EPA11 & EPA12 to end of array
      @epa_masters = @epa_masters.rotate(2)
    end
    @full_name = @user.full_name
    @user_id = @user.id
    if @epa_masters.empty?
      if (@user.new_competency) or (@user.username == 'peterbogus' or Date.today.strftime("%Y/%m/%d") >= "2025/07/01" ) ## Med28 student and
        hf_create_new_epas(@user.id, @user.email, @eg_cohorts)
      else
        create_epas @user.id, @user.email
      end
      @epa_masters = EpaMaster.where(user_id: @user.id).order(:id)
    elsif @user.new_competency || Date.today.strftime("%Y/%m/%d") >= "2025/07/01"
      EpaMaster.split_epa1(@user)
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

  def query_ai
    @responses = nil
    if params[:full_name].present?
      @full_name = params[:full_name].gsub(", ", "_").gsub(" ", "_")

      file_name = "#{Rails.root}/tmp/epa_reviews/ai_data_input/#{@full_name}_ai.txt"
      @question = 'Question="Use the EPA and EPA_KEYWORDS above and evaluate all the MSPE comments to see whether the student A can perform the EPAs.  List the evidences by course name. "'

      # if File.exist?(file_name) && File.mtime(file_name) >=  2.days.ago   #&& current_user.spec_program == 'AccessAI'
         @content = File.read(file_name)
        # @eval_ai_content2 = @eval_ai_content2.gsub("\n", "<br />").gsub("**Disclaimer:**", "<b>**Disclaimer:**</b>").gsub("Evidence:", "<b>Evidence: </b>")
        # @eval_ai_content2 = @eval_ai_content2.gsub("FileName", "<h5 style='color:purple;'>FileName").gsub("AI Responses:", "AI Responses: </h5>")
        # @new_content, @question = hf_parse_ai_content(@eval_ai_content2)
        # #have to load the initial input data from google_ai_data folder
        # full_name = params[:full_name].gsub(", ", "_").gsub(" ", "_")
        # file_output = "#{Rails.root}/tmp/epa_reviews/google_ai_data/#{full_name}_ai.txt"
        # File.open(file_output, 'w') { |file| file.write(@new_content) }
        # file_output = "#{Rails.root}/tmp/epa_reviews/chatgpt_ai_data/#{full_name}_ai.txt"
        # File.open(file_output, 'w') { |file| file.write(@new_content) }

      # elsif current_user.spec_program == 'AccessAI'
        #@full_name = params[:full_name].gsub(", ", "_").gsub(" ", "_")
        @user_id = params[:user_id]
        epa_masters = EpaMaster.where(user_id: @user_id, status: nil).order(:epa)

        @content = get_mspe_feedback(epa_masters)
        last_name, first_name = params[:full_name].split(", ")
        mod_name = first_name + " " + last_name
        @content = @content.gsub(first_name, "Student A").gsub(last_name, "Student A").gsub(mod_name, "Student A").gsub("Student A Student A", "Student A")

        file_output = "#{Rails.root}/tmp/epa_reviews/ai_data_input/#{@full_name}_ai.txt"
        File.open(file_output, 'w') { |file| file.write(@content) }
        @content = @content.gsub("\n", "<br>")
        last_name, first_name = params[:full_name].split(", ")
        mod_name = first_name + " " + last_name
        @content = @content.gsub(first_name, "Student A").gsub(last_name, "Student A").gsub(mod_name, "Student A").gsub("Student A Student A", "Student A")
        @responses = load_ai_data(@full_name)
      # end

      # @content = @content.gsub("\n", "<br>")
      # last_name, first_name = params[:full_name].split(", ")
      # mod_name = first_name + " " + last_name
      # @content = @content.gsub(first_name, "Student A").gsub(last_name, "Student A").gsub(mod_name, "Student A").gsub("Student A Student A", "Student A")
      # @responses = load_ai_data(@full_name)

    end
    if  params[:aiOption].present?
      @full_name = params[:mod_full_name]  ## this one is hidder in the form
      file_output = "#{Rails.root}/tmp/epa_reviews/ai_data_input/#{@full_name}_ai.txt"
      File.open(file_output, 'a') { |file| file.write(params[:ai_question]) }

      # exec python script here
      # python script will read the file from tmp/epa_reviews/ai_data/ folder
      #   1) Call AI either Google or Open AI
      #   2) the script will output the response to the same file
      # The controller here will parse out the response from the output file & display it on the screen
      # @response will contain the ultimate response from AI

      prog_path = "#{Rails.root}/config"
      log_path = "#{Rails.root}/log/#{@full_name}_ai.log"
      data_path = "#{Rails.root}/tmp/epa_reviews"

      python_script_output = system("/usr/bin/python3 #{prog_path}/#{params[:aiOption].first}_ai_eg_review.py #{data_path} #{@full_name} #{params[:aiOption].first} > #{log_path} 2>&1")

      @responses = (params[:ai_question].to_s + "<br>" )
      file_name = "#{Rails.root}/tmp/epa_reviews/#{ params[:aiOption].first}_ai_data/#{@full_name}_ai.txt"
      @new_responses = File.read(file_name)

      @ai_responses = hf_parse_new_ai_content(@new_responses, params[:aiOption].first)
      @ai_responses = @ai_responses.gsub("\n", "<br />")
      @responses = (@responses + @ai_responses)
    end
    respond_to do |format|
      format.html
      format.js {render template: 'epa_masters/query_ai'}
    end
  end

  def load_ai_data full_name

      file_name = "#{Rails.root}/tmp/epa_reviews/google_ai_data/#{full_name}_ai.txt"
      if File.exist?(file_name)
        @responses = File.read(file_name)
        @responses = @responses.gsub("\n", "<br />")
        @responses = @responses.gsub("Google", "<h5 style='color:purple;'>Google").gsub("AI Responses:", "AI Responses: </h5>")
      else
        @responses = "No Previous Google AI Responses Found! <br>"
      end
      @responses += "<br>" + ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" + "<br><br>"
      file_name = "#{Rails.root}/tmp/epa_reviews/chatgpt_ai_data/#{full_name}_ai.txt"
      if File.exist?(file_name)
        @responses += File.read(file_name)
        @responses = @responses.gsub("\n", "<br />")
        @responses = @responses.gsub("ChatGPT", "<h5 style='color:blue;'>ChatGPT").gsub("AI Responses:", "AI Responses: </h5>")
      else
        @responses += "No Previous ChatGPT AI Responses Found! <br>"
      end

  end

  # DELETE /epa_masters/1
  def destroy
    @epa_master.destroy
    redirect_to epa_masters_url, notice: 'Epa master was successfully destroyed.'
  end

  def epa_qa
    if params[:permission_group_id].present?
        @cohort_title = @permission_groups.select{|p| p.title if p.id == params[:permission_group_id].to_i}.first.title
        @epa_qa_data = hf_process_cohort2(params[:permission_group_id], "", "", "EPA")
        create_file @epa_qa_data, "epa_qa.txt"
        respond_to do |format|
          format.html
          format.js
        end
     end
     #render :epa_qa
  end

  def average_wba_epa
    if params[:permission_group_id].present?
        @cohort_title = @permission_groups.select{|p| p.title if p.id == params[:permission_group_id].to_i}.first.title
        @cohort = @cohort_title.scan(/\((.*)\)/).first.first

        @start_date = params[:StartDate]
        @end_date = params[:EndDate]
        if @start_date == "" and @end_date == ""
          @start_date = "2016-01-01"  # default date
          @end_date = "2030-02-18"  #default date
        elsif @end_date == ""
          @end_date = "2030-02-18"  #default date
        end
        @level_epa_wbas_count_hash = hf_count_level_wbas(params[:permission_group_id], @cohort, @cohort_counts, @start_date, @end_date)
        @average_level_epa_wbas_hash = hf_average_level_wbas(params[:permission_group_id], @start_date, @end_date)

        create_file2 @average_level_epa_wbas_hash, "#{@cohort}_average_wba_epa.txt"
        respond_to do |format|
          format.html
        end
     end
     render :average_wba_epa
  end

  def wba_epa
    if params[:permission_group_id].present?
        @cohort_title = PermissionGroup.find(params[:permission_group_id]).title
        @start_date = params[:StartDate]
        @end_date = params[:EndDate]
        if @start_date == "" and @end_date == ""
          @start_date = "2016-01-01"  # default date
          @end_date = "2030-02-18"  #default date
        elsif @end_date == ""
          @end_date = "2030-02-18"  #default date
        end
        @wba_epa_data = hf_process_cohort2(params[:permission_group_id], @start_date, @end_date, "WBA")
        @wba_epa_data = @wba_epa_data.sort_by{ |wba| wba["TotalCount"] }.reverse

        create_file @wba_epa_data, "wba_epa.txt"
        respond_to do |format|
          format.html
        end
     end
     render :wba_epa
  end

  def wba_clinical  #get clinical assessor data/count
    if params[:permission_group_id].present?
        @cohort_title = @permission_groups.select{|p| p.title if p.id == params[:permission_group_id].to_i}.first.title
        @wba_clinical_data = hf_process_cohort2(params[:permission_group_id], "", "", "ClinicalAssessor")
        create_file @wba_clinical_data, "wba_clinical_assessor.txt"
        respond_to do |format|
          format.html
        end
     end
     render :wba_clinical
  end

  def download_file
      if params[:file_name].present?
        private_download params[:file_name]
        # generic_file_name = params[:file_name]
        # send_file  "#{Rails.root}/tmp/#{generic_file_name}", type: 'text', disposition: 'download'
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
      @epa_badged_count, @student_epa_count = EpaMaster.process_epa_badged epa_badged, params[:cohort]

    end
    respond_to do |format|
      format.html
    end
    render :eg_badged
  end

  def badged_graph
    @all_cohorts_badges = EpaMaster.process_all_cohorts(@permission_groups)
    respond_to do |format|
      format.html
    end
  end

  def wba_epa_graph
    @all_cohorts_wba_epa = EpaMaster.process_all_cohorts_wba_epa(@permission_groups)

    respond_to do |format|
      format.html
    end
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

    def private_download in_file
      send_file  "#{Rails.root}/tmp/#{in_file}", type: 'text', disposition: 'download'
    end

    def set_resources
      @permission_groups = PermissionGroup.where(" id >= ? and id <> ?", 13, 15).order(:id)
      #@api_keys ||= YAML.load_file("config/ai_api_keys.yml")
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
      @all_cohorts ||= hf_load_eg_cohorts2

      @cohort_counts = {}
      @all_cohorts.each do |cohort|
        if @cohort_counts[cohort["cohort"]]
          @cohort_counts[cohort["cohort"]] += 1
        else
          @cohort_counts[cohort["cohort"]] = 1
        end
      end

      @uniq_cohorts = PermissionGroup.where("title like '%Med%' and id >= ?", 13).select(:id, :title).order(:id)
      # EgCohort.distinct.pluck(:permission_group_id).sort
      #@uniq_cohorts ||= @all_cohorts.map{|eg| eg["cohort"]}.uniq
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

    def create_file2 (in_data, in_file)
      file_name = "#{Rails.root}/tmp/#{in_file}"

      CSV.open(file_name,'wb', col_sep: "\t") do |csvfile|
        csvfile << ["StudentId", "Student Name"] + in_data.first["Ave Involvement"].keys #.first.keys.map{|c| c.titleize}
        in_data.each do |data|
          epa_values = []
          epa_values.push data["StudentId"]
          epa_values.push data["Student Name"]
          epa_values = epa_values + data["Ave Involvement"].values
          csvfile << epa_values
        end

      end
    end


end
