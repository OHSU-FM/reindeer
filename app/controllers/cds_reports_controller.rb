class CdsReportsController < ApplicationController
  layout 'full_width_margins'
  before_action :authenticate_user!
  before_action :set_resources
  respond_to :json, :html

  def index
    if params[:user_id].present? and params[:user_id].to_s != ""
      @coach_name = User.find(params[:user_id]).full_name
      @cohorts  = Cohort.where(user_id: params[:user_id]).order('title ASC').includes(:users)
    else
      @coach_name = "ALL"
      @cohorts ||= Cohort.all.order('title ASC').includes(:users)
    end
    render :index
  end

  def past_due
    if params[:startDate].present?
      @start_date = params[:startDate]
      @end_date = params[:endDate]

      # @past_due_mons = params[:past_due_mons]
      @student_goal_meeting = params[:student_goal_meeting]
    end
  end

  def by_subject

  end

  private
  def set_resources
    @coaches = User.where(coaching_type: 'coach').order('full_name ASC')
    @cohorts = Cohort.all.order('title ASC').includes(:users)
    @student_groups = PermissionGroup.where(" title like ?", "%Student%").order('title DESC')
    @uniq_subjects ||= Coaching::Meeting.distinct.pluck(:subject).flatten

  end
end
