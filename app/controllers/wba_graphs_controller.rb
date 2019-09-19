class WbaGraphsController < ApplicationController
  include WbaGraphsHelper
  layout 'full_width_csl'
  before_action :authenticate_user!


  def index

    #
    # @wba = Epa.all
    # @epa = @wba.group(:epa).count.sort_by{|k,v| v}.reverse
    # #@categories = @epa.map{|k,v| k}
    # @data = @epa.map{|k,v| v}

    if params[:category_id].present?
      @chart = hf_series_data(params[:category_id])
    elsif params[:emai].present?
        puts "it has emai: " + email
    end

    @student_groups = PermissionGroup.select(:id, :title).where("title Like ?", "%Students%").order(:title)
    @cohort_students = []
    if params[:permission_group_id].present?
      @cohort_students = User.select(:id, :full_name).where(permission_group_id: params[:permission_group_id]).order(:full_name)
    end
    if request.xhr?
      respond_to do |format|
        format.json {
          render json: {cohort_students: @cohort_students}
        }
      end
    else
      respond_to do |format|
        format.html
      end
    end

    @most_fours, @total_count_fours = most_fours
    @most_ones, @total_count_ones = most_ones
    #@med21_cohort = User.select(:email, :full_name).where(permission_group_id: 13).order(:full_name)
  end

  def get_entrustment_data
    if params[:user_id].present?
      @user = User.select(:id, :email, :full_name, :permission_group_id).where(id: params[:user_id])
      @clinical_data = hf_get_clinical_dataset(@user, 'Clinical')
      @percent_complete = hf_epa_class_mean(@clinical_data)
      @preceptorship_data = hf_get_clinical_dataset(@user, 'Preceptorship')
      @wba = hf_get_wbas(@user.first.id)
      @csl_data = hf_get_csl_datasets(@user, 'CSL Narrative Assessment')
      @artifacts_student, @no_official_docs, @shelf_artifacts = hf_get_artifacts(@user.first.email, "Progress Board")
      @today_date = Time.new.strftime("%m/%d/%Y")
    end
    if request.xhr?
      respond_to do |format|
          format.js {render action: "get_entrustment_data", status: :ok }
      end
    else
      respond_to do |format|
        format.html
      end
    end

  end

  def show
  end

  private
  def most_fours
    array_fours ||= Epa.where(involvement: 4).select(:involvement).group(:assessor_name).count
    sorted = array_fours.sort_by{|k,v| v}.reverse
    total_count_fours = Epa.where(assessor_name: "#{sorted[0].first}").count

    return sorted[0], total_count_fours

  end

  def most_ones
    array_fours ||= Epa.where(involvement: 1).select(:involvement).group(:assessor_name).count
    sorted = array_fours.sort_by{|k,v| v}.reverse
    total_count_ones = Epa.where(assessor_name: "#{sorted[0].first}").count
    return sorted[0], total_count_ones

  end


end
