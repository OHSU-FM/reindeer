class StudentAssessmentsController < ApplicationController
  layout 'full_width_csl'
  before_action :authenticate_user!, :load_cohorts_menu
  respond_to :html, :json

  helper  :all

  def show

    if params[:id].present?
      @id = params[:id]
      @students ||= User.where(permission_group_id: params[:id]).select(:id, :email, :username, :full_name).order(:full_name)
    end

    if params[:email].present?
      @results = []
      @results.push User.find_by(email: params[:email])
    end

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
         if current_user.spec_program == 'PhD'
           @students ||= User.where("spec_program like 'MD/PhD%'").select(:id, :email, :username, :full_name).order(:full_name)
         elsif current_user.spec_program == 'MPH'
           @students ||= User.where("spec_program like 'MD/MPH%'").select(:id, :email, :username, :full_name).order(:full_name)
         else
           @cohorts_menu ||= PermissionGroup.where("id >= ? and id <> 15", 13).order(:title).uniq
         end
      end
  end


end
