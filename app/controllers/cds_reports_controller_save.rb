class CdsReportsController < ApplicationController
  layout 'full_width_margins'
  before_action :authenticate_user!
  before_action :set_resources
  include CdsReportsHelper

  def index

    @cohorts_total ||= hf_get_cohort_students
    if params[:user_id].present?
      cohorts  = Cohort.where(user_id: params[:user_id]).order('title ASC').includes(:users)
    else
      cohorts ||= Cohort.all.order('title ASC').includes(:users)
      # @goals_data ||= hf_total_active_goals(cohorts)
      # @past_data ||= hf_get_past_data(cohorts)
    end
    @coaches_not_met_past_2_months = hf_get_coaches_not_met_past_2_months(cohorts)
    @cds = hf_cds_reporting(cohorts)

  end

  private
  def set_resources
    @coaches = User.where(coaching_type: 'coach').order('full_name ASC')
    cohorts = Cohort.all.order('title ASC').includes(:users)
    @goals_data = CdsReportsHelper.get_total_active_goals(cohorts)
    @past_data = hf_get_past_data(cohorts)
  end

end
