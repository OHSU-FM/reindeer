class OverallProgressesController < ApplicationController
before_action :authenticate_user!
before_action :set_resources

include CompetenciesHelper

  def index
    if params[:user_id].present?
      if (current_user.coaching_type == 'student' and current_user.id == params[:user_id].to_i)
        load_data(current_user.id)
      elsif (current_user.coaching_type == 'dean' or current_user.coaching_type=='admin')
        load_data (params[:user_id])
      else
        render "error_page"
      end
    end
  end

  def load_data(user_id)
    @no_wbas = Epa.where(user_id: user_id).count
    @no_badges = EpaMaster.where(user_id: user_id, status: 'Badge').count
    cohort_title = User.find(user_id).permission_group.title.split(" ").last.gsub(/[()]/, "")

    @rem_wbas = @cohort_wba[cohort_title] - @no_wbas
    if @rem_wbas >= 0
      @per_wbas = (@no_wbas/@cohort_wba[cohort_title].to_f*100).round
    else 
      @per_wbas = 100
    end
    @comp = Competency.where(user_id: user_id).order(start_date: :desc)
    @comp = @comp.map(&:attributes)
    @comp_hash3 = hf_load_all_comp2(@comp, 3)
    @comp_data_clinical = hf_average_comp2 (@comp_hash3)
    @student_epa ||= hf_epa2(@comp_data_clinical)
    @ave_epa = @student_epa.values.sum/13  # 13 EPAs

    @ave_comp = @comp_data_clinical.values.sum/43  # 43 competencies
  end

  private
  def set_resources
    @cohort_wba ||= YAML.load_file("config/wba.yml")
  end



end
