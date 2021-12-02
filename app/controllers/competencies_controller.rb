class CompetenciesController < ApplicationController
  layout 'full_width_csl'
  before_action :authenticate_user!, :load_release_date
  include CompetenciesHelper
  include LsReports::CslevalHelper
  include LsReports::ClinicalphaseHelper
  include EpasHelper
  include WbaGraphsHelper
  include ArtifactsHelper
  include EpaMastersHelper
  include FomExamsHelper


  def index

    @non_clinical_course_arry ||= hf_get_non_clinical_courses

    if current_user.coaching_type == "student"
      @selected_user = current_user
      full_name = current_user.full_name
      email = current_user.email
      permission_group_id = current_user.permission_group_id
      if !(@comp = Competency.where(user_id: current_user.id).order(start_date: :desc)).empty?
        load_competencies(permission_group_id, full_name)
      else
        @comp = nil
      end

    else
      if params[:user_id].present? and  !(@comp = Competency.where(user_id: params[:user_id]).order(start_date: :desc)).empty?
        @selected_user = User.where(id: params[:user_id]).first
        email = @selected_user.email
        # full_name = @selected_user.full_name
        # permission_group_id = @selected_user.permission_group_id
        load_competencies(@selected_user.permission_group_id, @selected_user.full_name)
      else
        @selected_user = User.where(id: params[:user_id]).first
        email = @selected_user.email
        @comp = hf_get_archive_competency(@selected_user.id, @selected_user.permission_group_id)
        if !@comp.nil?
          load_competencies(@selected_user.permission_group_id, @selected_user.full_name)
        end
      end
    end

    @full_name = @selected_user.full_name
    @pk = email
    @selected_user_year = @selected_user.permission_group.title.split(" ").last.gsub(/[()]/, "")

    @release_date = load_release_date["#{@selected_user_year}Badge"].blank? ? nil : load_release_date["#{@selected_user_year}Badge"]["releaseDate"]

    ## getting WPAs
     @epas, @epa_hash, @epa_evaluators, @unique_evaluators, @selected_dates, @selected_student, @total_wba_count = hf_get_epas(email)

     if !@epas.blank?
       gon.epa_adhoc = @epa_hash #@epa_adhoc
       gon.epa_evaluators = @epa_evaluators
       gon.unique_evaluators = @unique_evaluators
       gon.selected_dates = @selected_dates
       gon.selected_student = @selected_student
       gon.total_wba_count = @total_wba_count
     end

     @preceptorship_data = hf_get_clinical_dataset(@selected_user, 'Preceptorship')
     preceptor_assesses = PreceptorAssess.where(user_id: @selected_user).map(&:attributes) ## med23 preceptor evaluations
     @preceptor_assesses = hf_collect_values(preceptor_assesses)

     @csl_data = hf_get_csl_datasets(@selected_user, 'CSL Narrative Assessment')
     @csl_feedbacks = CslFeedback.where(user_id: @selected_user.id).order(:submit_date)

     if @selected_user.permission_group_id >= 17
       @all_blocks, @all_blocks_class_mean, @category_labels = Competency.all_blocks_mean(@selected_user)
     else
       @all_blocks, @all_blocks_class_mean, @category_labels =  hf_get_clinical_dataset(@selected_user, 'All Blocks')
     end

     @official_docs, @no_official_docs, @shelf_artifacts = hf_get_artifacts(@pk, "Progress Board")
     @mock_artifacts = hf_get_mock(@pk, "Mock Step 1")

     @cpx_data_new, @not_found_cpx, @cpx_artifacts = hf_get_new_cpx(@pk)

     found_rec = FileuploadSetting.find_by(permission_group_id: current_user.permission_group_id)
     if found_rec.nil?
       @usmle_exams = UsmleExam.where("user_id=? and exam_type <>'HSS'", @selected_user.id).order(:exam_type, :no_attempts)
     elsif found_rec.visible == false
       @usmle_exams = UsmleExam.where("user_id=? and exam_type not like ?", @selected_user.id, "%Mock%").order(:exam_type, :no_attempts)
     else
       @usmle_exams = UsmleExam.where("user_id=? and exam_type <>'HSS'", @selected_user.id).order(:exam_type, :no_attempts)       
     end

     @hss_exams   = UsmleExam.where(user_id: @selected_user.id, exam_type: 'HSS').order(:exam_type, :no_attempts)

     @student_badge_info = hf_get_badge_info(@selected_user.id)


     #if @not_found_cpx
      # @cpx_data = hf_get_cpx(@survey)
     #end

     render :index
  end

  def load_competencies(permission_group_id, full_name)
    @comp = @comp.map(&:attributes)

    @comp_hash3 = hf_load_all_comp2(@comp, 3)
    @comp_hash2 = hf_load_all_comp2(@comp, 2)
    @comp_hash1 = hf_load_all_comp2(@comp, 1)
    @comp_hash0 = hf_load_all_comp2(@comp, 0)

    @comp_data_clinical = hf_average_comp2 (@comp_hash3)

    if [3,5,6,13].include? permission_group_id
      @comp_class_mean = Competency.load_class_mean(permission_group_id)
      if @comp_class_mean.nil?
        @comp_unfiltered = Competency.where(permission_group_id: permission_group_id).map(&:attributes)
        if @comp_unfiltered.empty?
          # get it from archived tables
          group_title = PermissionGroup.find(permission_group_id).title.scan(/\((.*)\)/).first.first
          table_name = "#{group_title}Competency".constantize
          @comp_unfiltered = table_name.where(permission_group_id: permission_group_id).map(&:attributes)
        end

        @comp_class_mean = hf_competency_class_mean2(@comp_unfiltered)
        Competency.create_class_mean(@comp_class_mean, permission_group_id)
      end
    else
      @comp_class_mean = Competency.load_class_mean(permission_group_id)
      if @comp_class_mean.nil?
        @comp_unfiltered = Competency.where(permission_group_id: permission_group_id).map(&:attributes)
        @comp_class_mean = hf_competency_class_mean2(@comp_unfiltered)
        Competency.create_class_mean(@comp_class_mean, permission_group_id)
      end
    end

    @chart ||= hf_create_chart('Competency', @comp_data_clinical, @comp_class_mean, full_name)
    @student_epa ||= hf_epa2(@comp_data_clinical)

    @epa_class_mean ||= hf_epa2(@comp_class_mean)
    @chart_epa ||= hf_create_chart('EPA', @student_epa, @epa_class_mean, full_name)

  end

  private

  def load_release_date
    badge_release_date ||= YAML.load_file("config/badgeReleaseDate.yml")

  end

end
