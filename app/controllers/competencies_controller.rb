class CompetenciesController < ApplicationController
  layout 'full_width_csl'
  before_action :authenticate_user!
  include CompetenciesHelper
  include LsReports::CslevalHelper
  include LsReports::ClinicalphaseHelper
  include EpasHelper
  include WbaGraphsHelper
  include ArtifactsHelper

  def index

    @non_clinical_course_arry ||= hf_get_non_clinical_courses

    # if business = Business.where(:user_id => current_user.id).first
    #   business.do_some_stuff
    # else
    #   # do something else
    # end

    if current_user.coaching_type == "student"
      @user = current_user
      full_name = current_user.full_name
      email = current_user.email
      permission_group_id = current_user.permission_group_id
      if !(@comp = Competency.where(user_id: current_user.id).order(:submit_date)).empty?
        load_competencies(permission_group_id, full_name)
      else
        @comp = nil
      end

    else
      if !(@comp = Competency.where(user_id: params[:user_id]).order(:submit_date)).empty?
        @user = User.where(id: params[:user_id])
        full_name = @user.first.full_name
        email = @user.first.email
        permission_group_id = @user.first.permission_group_id
        load_competencies(permission_group_id, full_name)
      else
        @user = User.where(id: params[:user_id])
        email = @user.first.email
        @comp = nil
      end
    end


    @pk = email
    @student_year = @user.first.cohort.title.split(" - ").last

    ## getting WPAs
     @epas, @epa_hash, @epa_evaluators, @unique_evaluators, @selected_dates, @selected_student, @total_wba_count = hf_get_epas(email)
     if !@epas.empty?
       gon.epa_adhoc = @epa_hash #@epa_adhoc
       gon.epa_evaluators = @epa_evaluators
       gon.unique_evaluators = @unique_evaluators
       gon.selected_dates = @selected_dates
       gon.selected_student = @selected_student
       gon.total_wba_count = @total_wba_count
     end

     @preceptorship_data = hf_get_clinical_dataset(@user, 'Preceptorship')
     @csl_data = hf_get_csl_datasets(@user, 'CSL Narrative Assessment')
     if @csl_data.empty?
       @csl_feedbacks = CslFeedback.where(user_id: @user.first.id).order(:submit_date)
       @csl_data = []
     end
     @all_blocks, @all_blocks_class_mean, @category_labels =  hf_get_clinical_dataset(@user, 'All Blocks')
     @artifacts_student, @no_official_docs, @shelf_artifacts = hf_get_artifacts(@pk, "Progress Board")

     @cpx_data_new, @not_found_cpx, @cpx_artifacts = hf_get_new_cpx(@pk)
     @usmle_exams = UsmleExam.where(user_id: @user.first.id).order(:exam_type, :no_attempts)
     #if @not_found_cpx
      # @cpx_data = hf_get_cpx(@survey)
     #end

  end

  def load_competencies(permission_group_id, full_name)
    @comp = @comp.map(&:attributes)

    @comp_hash3 = hf_load_all_comp2(@comp, 3)
    @comp_hash2 = hf_load_all_comp2(@comp, 2)
    @comp_hash1 = hf_load_all_comp2(@comp, 1)
    @comp_hash0 = hf_load_all_comp2(@comp, 0)

    @comp_data_clinical = hf_average_comp2 (@comp_hash3)

    @comp_class_mean = Competency.load_class_mean(permission_group_id)
    if @comp_class_mean.nil?
      @comp_unfiltered = Competency.where(permission_group_id: permission_group_id).map(&:attributes)
      @comp_class_mean = hf_competency_class_mean2(@comp_unfiltered)
      Competency.create_class_mean(@comp_class_mean, permission_group_id)
    end

    @chart ||= hf_create_chart('Competency', @comp_data_clinical, @comp_class_mean, full_name)
    @student_epa ||= hf_epa2(@comp_data_clinical)
    @epa_class_mean ||= hf_epa2(@comp_class_mean)
    @chart_epa ||= hf_create_chart('EPA', @student_epa, @epa_class_mean, full_name)

  end

end
