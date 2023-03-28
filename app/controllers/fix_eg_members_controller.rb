class FixEgMembersController < ApplicationController
  layout 'full_width_csl'
  before_action :authenticate_user!
  before_action :load_eg_cohorts, :set_resources
  include FixEgMembersHelper


  def index
    if params[:uniq_cohort].present? and (params[:uniq_cohort] == 'CaseStudies' or params[:uniq_cohort] == 'CaseStudies2')
      @eg_cohorts = @all_cohorts.select{|eg| eg if eg["cohort"] == params[:uniq_cohort] }
    elsif params[:uniq_cohort].present?
      #@eg_cohorts = @all_cohorts.select{|eg| eg if eg["permission_group_id"] == params[:uniq_cohort].to_i and (eg["eg_email1"] == current_user.email or eg["eg_email2"] == current_user.email)}
      @eg_cohorts = EpaMaster.get_all_eg_cohorts(params[:uniq_cohort])
    end
    if params[:email].present?
      @user = User.find_by(email: params[:email])
      load_epa_masters
    end

  end

  def reviewer_update

    if params[:user_id].present?
      @user = User.find_by(id: params[:user_id])
       session[:user_id] = params[:user_id]
      load_epa_masters
    elsif params[:reviewer1].present? and params[:reviewer2].present?
      @user = User.find_by(id: session[:user_id])
      load_epa_masters
      hf_update_reviewers(@epa_masters, params[:reviewer1], params[:reviewer2])
      @user = User.find_by(id: session[:user_id])
      load_epa_masters
    end
    render :reviewer_update
  end

  def load_epa_masters
    @epa_masters = @user.epa_masters.order(:id)
    @full_name = @user.full_name
    # if @epa_masters.empty?
    #   create_epas @user.id, @user.email
    #   @epa_masters = EpaMaster.where(user_id: @user.id).order(:id)
    # end

    respond_to do |format|
      format.html
    end
  end

  private

  def set_resources
    @permission_groups = PermissionGroup.where(" id >= ? and id <> ?", 13, 15).order(:id)
    @newest_cohort = EgCohort.pluck(:permission_group_id).uniq.max
    @reviewer1 = EgCohort.where(permission_group_id: @newest_cohort).pluck(:eg_full_name1).uniq.sort
    @reviewer2 = EgCohort.where(permission_group_id: @newest_cohort).pluck(:eg_full_name2).uniq.sort
  end


  def load_eg_cohorts
    @all_cohorts ||= hf_load_eg_cohorts2

    @uniq_cohorts = PermissionGroup.where("title like '%Med%' and id >= ?", 13).select(:id, :title).order(:id)
    # EgCohort.distinct.pluck(:permission_group_id).sort
    #@uniq_cohorts ||= @all_cohorts.map{|eg| eg["cohort"]}.uniq
    @uniq_eg_members ||= @all_cohorts.map{|c| [c["eg_full_name1"], c["eg_full_name2"]]}.flatten.uniq.compact.sort
    @uniq_eg_members = ["All"] + @uniq_eg_members
  end

end
