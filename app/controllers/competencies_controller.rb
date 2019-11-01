class CompetenciesController < ApplicationController
  layout 'full_width_csl'
  before_action :authenticate_user!
  include CompetenciesHelper
  include LsReports::CslevalHelper
  include EpasHelper

  def index
    @non_clinical_course_arry ||= hf_get_non_clinical_courses

    # if business = Business.where(:user_id => current_user.id).first
    #   business.do_some_stuff
    # else
    #   # do something else
    # end

    if current_user.coaching_type == "student"
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
        byebug
        @student_info = @comp.first.user
        full_name = @student_info.full_name
        email = @student_info.email
        permission_group_id = @student_info.permission_group_id
        load_competencies(permission_group_id, full_name)
      else
        email = User.find(params[:user_id]).email
        @comp = nil
      end
    end

    @pk = email

    ## getting WPAs
     @epas, @epa_hash, @epa_evaluators, @unique_evaluators, @selected_dates, @selected_student, @total_wba_count = hf_get_epas(email)
    # gon.epa_adhoc = @epa_hash #@epa_adhoc
    # gon.epa_evaluators = @epa_evaluators
    # gon.unique_evaluators = @unique_evaluators
    # gon.selected_dates = @selected_dates
    # gon.selected_student = @selected_student
    # gon.total_wba_count = @total_wba_count


  end

  def load_competencies(permission_group_id, full_name)
    @comp = @comp.map(&:attributes)

    @comp_hash3 = hf_load_all_comp2(@comp, 3)
    @comp_hash2 = hf_load_all_comp2(@comp, 2)
    @comp_hash1 = hf_load_all_comp2(@comp, 1)
    @comp_hash0 = hf_load_all_comp2(@comp, 0)

    @comp_data_clinical = hf_average_comp (@comp_hash3)
    @comp_class_mean = Competency.load_class_mean(permission_group_id)
    if @comp_class_mean.nil?
      @comp_unfiltered = Competency.where(permission_group_id: permission_group_id).map(&:attributes)
      @comp_class_mean = hf_competency_class_mean(@comp_unfiltered)
      Competency.create_class_mean(@comp_class_mean, permission_group_id)
    end

    @chart = hf_create_chart('Competency', @comp_data_clinical, @comp_class_mean, full_name)

    @student_epa = hf_epa(@comp_data_clinical)
    @epa_class_mean = hf_epa(@comp_class_mean)
    @chart_epa = hf_create_chart('EPA', @student_epa, @epa_class_mean, full_name)
  end

end
