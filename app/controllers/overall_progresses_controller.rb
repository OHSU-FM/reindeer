class OverallProgressesController < ApplicationController
before_action :authenticate_user!
before_action :set_resources

include OverallProgressesHelper
include CompetenciesHelper
include NewCompetenciesHelper

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
    @user = User.find(user_id)
    if @user.new_competency?
      @no_wbas = Epa.where("user_id = ? and (epa <> 'EPA12' or epa <> 'EPA13')",  user_id).count
      @wbas_epas =  Epa.where("user_id = ? and epa <> 'EPA12' and epa <> 'EPA13'",  user_id).group(:epa).count
      # disabled on 7/22/2025 due to complex EPA1A&1B, etc
      # @wbas_epas_per = hf_compute_wba_epa(@wbas_epas, @user.new_competency)

      @wbas_attg = Epa.where("user_id = ? and clinical_assessor = ?",  user_id, 'Attending Faculty').count
      @no_badges = EpaMaster.where(user_id: user_id, status: 'Badge').where.not(epa: ["EPA12", "EPA13"]).count
      @no_badges_per = (@no_badges/12.0*100).round

    else
      @no_wbas = Epa.where(user_id: user_id).count
      @wbas_epas =  Epa.where(user_id: user_id).group(:epa).count
      @wbas_epas_per = hf_compute_wba_epa(@wbas_epas, @user.new_competency)
      @wbas_attg = Epa.where(user_id: user_id, clinical_assessor: 'Attending Faculty').count
      if @user.spec_program.include? "Paused badging"
        @no_badges = 0  # no badges shown on main page or overall progress
      else
        @no_badges = EpaMaster.where(user_id: user_id, status: 'Badge').count
        @no_badges_per = (@no_badges/13.0*100).round
      end
    end
    @wbas_attg_per = (@wbas_attg/51.0)
    if @wbas_attg_per > 1
      @wbas_attg_per = 100
    else
      @wbas_attg_per =(@wbas_attg_per*100).round
    end


    #result.epa_masters.where('status = ? and status_date < ?','Badge', hf_releaseDate(result)).count.to_s

    cohort_title = @user.permission_group.title.split(" ").last.gsub(/[()]/, "")

    @rem_wbas = @cohort_wba[cohort_title] - @no_wbas
    if @rem_wbas >= 0
      @per_wbas = (@no_wbas/@cohort_wba[cohort_title].to_f*100).round
    else
      @per_wbas = 100
    end

    if @user.new_competency?
      @comp = NewCompetency.where(user_id: user_id).order(start_date: :desc)
      @comp = @comp.map(&:attributes)
      @comp_hash3 = hf_load_all_new_competencies(@comp, 3)
      @comp_data_clinical = hf_average_comp_new (@comp_hash3)
      @student_epa ||= hf_new_epa(@comp_data_clinical)
      @ave_epa = @student_epa.values.sum/12  # 11 EPAs
      @ave_comp = @comp_data_clinical.values.sum/17  # 17 competencies

    else
      @comp = Competency.where(user_id: user_id).order(start_date: :desc)
      @comp = @comp.map(&:attributes)
      @comp_hash3 = hf_load_all_comp2(@comp, 3)
      @comp_data_clinical = hf_average_comp2 (@comp_hash3)
      @student_epa ||= hf_epa2(@comp_data_clinical)
      @ave_epa = @student_epa.values.sum/13  # 13 EPAs
      @ave_comp = @comp_data_clinical.values.sum/43  # 43 competencies
    end
  end

  private
  def set_resources
    @cohort_wba ||= YAML.load_file("config/wba.yml")
  end



end
