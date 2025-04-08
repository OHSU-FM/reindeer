class ReportsController < ApplicationController

  layout 'full_width_csl'
  protect_from_forgery prepend: true, with: :exception
  #authorize_resource class: ReportsController
  before_action :authenticate_user!, :set_resources
  include ReportsHelper
  include CompetenciesHelper

  def index
    if params[:cohort].present?
      @users = User.where(permission_group_id: params[:cohort]).select(:id, :full_name, :username, :email).order(:full_name)
      @cohort_title = PermissionGroup.find(params[:cohort]).title.scan(/\((.*)\)/).first.first
      @ranking_data = hf_get_ranking(@users)
      create_file @ranking_data, "#{@cohort_title}_ranking_data.txt"
    end
    respond_to do |format|
      format.html
    end

  end

  def competency
    if params[:cohortChecked].present?
      @cohortChecked = JSON.parse(params[:cohortChecked])
      @comp_class_means = {}

      @non_clinical_course_arry ||= hf_get_non_clinical_courses2

      @cohortChecked.each do |cohort_id|
        if cohort_id.to_i >= 16
          cohort_title = PermissionGroup.find(cohort_id.to_i).title.scan(/\((.*)\)/).first.first
          comp_unfiltered = Competency.joins(:user).where(permission_group_id: cohort_id).map(&:attributes)
          class_mean = hf_competency_class_mean2(comp_unfiltered)
          #class_mean.store("Cohort", cohort_title)
          @comp_class_means[cohort_title] = class_mean
        else
          cohort_title = PermissionGroup.find(cohort_id.to_i).title.scan(/\((.*)\)/).first.first
          comp_unfiltered = get_old_data(cohort_id.to_i)
          class_mean = hf_competency_class_mean2(comp_unfiltered)
          #class_mean.store("Cohort", cohort_title)
          @comp_class_means[cohort_title] = class_mean
        end
      end
      respond_to do |format|
        format.html
        format.js { render action: 'competency_data', status: 200 }
      end
    end
  end

  def mspe

    if current_user.coaching_type != 'student'

      if params[:cohort].present? and  params[:email].present? and params[:email] != 'All'
        #@mspe_data = hf_get_mspe_data(params[:cohort])
        @student_email = params[:email]
        @mspe_data, @mspe_filename = hf_get_mspe_data_by_email(params[:email], params[:cohort])
      elsif params[:cohort].present? and  params[:email].present? and params[:email] == 'All'
        @mspe_data, @mspe_filename = hf_get_mspe_data(params[:cohort])

      end

      respond_to do |format|
        format.html
        # format.js { render partial: 'mspe_data', status: 200 }
      end
    end
  end

  def download_file
      if params[:file_name].present?
        private_download params[:file_name]
      end
  end

  private

  def set_resources
    # group 7 is phd/mph/mcr students
    # group 11 is dismissed or discharged students
    @permission_groups ||= PermissionGroup.where("id < 20 and id not in (7,11) and title like ?", "%Student%").order(:id) # get last 3 rows
    @permission_groups_mspe ||= PermissionGroup.where("id >= ? and title like ?", 17, "%Student%").order(:id) # get last 3 rows
  end

  def private_download in_file
     send_file  "#{Rails.root}/tmp/#{in_file}", type: 'text', disposition: 'download'
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

  def get_old_data(cohort_id)
    case cohort_id
    when 3
      comp_data = Med18Competency.joins(:user).where(permission_group_id: cohort_id).map(&:attributes)
    when 5
      comp_data = Med19Competency.joins(:user).where(permission_group_id: cohort_id).map(&:attributes)
    when 6
      comp_data = Med20Competency.joins(:user).where(permission_group_id: cohort_id).map(&:attributes)
    when 13
      comp_data = Med21Competency.joins(:user).where(permission_group_id: cohort_id).map(&:attributes)
    end
    return comp_data
  end


end
