class PreceptorEvalsController < ApplicationController
  before_action :authenticate_user!
  include PreceptorEvalsHelper
  include CompetenciesHelper

  def index
    @preceptor_evals = PreceptorEval.where(user_id: params[:user_id], permission_group_id: params[:permission_group_id]).includes(:user).sort.reverse
    @student_name = @preceptor_evals.first.user.full_name
    preceptor_evals_hash = @preceptor_evals.map(&:attributes)
    respond_to do |format|
      format.html
    end
  end

end
