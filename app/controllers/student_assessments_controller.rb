class StudentAssessmentsController < ApplicationController
  layout 'full_width_csl'
  before_action :authenticate_user!, :load_cohorts_menu
  respond_to :html, :json

  helper  :all

  def show

    if params[:id].present?
      @id = params[:id]
      @students ||= Cohort.find(params[:id]).users.select(:id, :email, :username, :full_name).order(:full_name)
    end

    if params[:email].present?
      @results = []
      @results.push User.find_by(email: params[:email])
    end

    # if request.xhr?
    #   respond_to do |format|
    #     format.json {
    #       render json: {cohort_students: @cohort_students}
    #     }
    #   end
    # end
    render :show
  end

  def search
    if params[:email].present?
      @results = []
      @results.push User.find_by(email: params[:email])
    end
    render :show
  end


  private

  def load_cohorts_menu
      if current_user.coaching_type == 'coach'
        @cohorts_menu ||= current_user.cohorts.where("permission_group_id >= ?", 13).order(:title)
      elsif current_user.dean_or_higher?
          @cohorts_menu ||= Cohort.where("permission_group_id >= ?", 13).order(:title).uniq
      end
  end


end
