class CdsReportsController < ApplicationController
  layout 'full_width_margins'
  before_action :authenticate_user!
  before_action :set_resources
  include CdsReportsHelper

  def index
    @cohorts_total = hf_get_cohort_students
    @past_data = hf_get_past_data
    if params[:user_id].present?
      @coaches_not_met_past_2_months = hf_get_coaches_not_met_past_2_months(params[:user_id])
      @cds = hf_cds_reporting(params[:user_id])
    else
      @coaches_not_met_past_2_months = hf_get_coaches_not_met_past_2_months("All")
      @cds = hf_cds_reporting('All')
    end

  end

  private
  def set_resources
        @coaches = User.where(coaching_type: 'coach').order('full_name ASC')
  end

end
