class PreceptorEvalsController < ApplicationController
  before_action :authenticate_user!
  include PreceptorEvalsHelper
  include CompetenciesHelper

  # def index
  #   @preceptor_evals = PreceptorEval.where(user_id: params[:user_id]).includes(:user).sort.reverse
  #   if !@preceptor_evals.empty?
  #     @student_name = @preceptor_evals.first.user.full_name
  #     preceptor_evals_hash = @preceptor_evals.map(&:attributes)
  #   end
  #   respond_to do |format|
  #     format.html
  #   end
  # end

  def show
    if params[:uuid].present?
      user = User.find_by(uuid: params[:uuid])
      @preceptor_evals = PreceptorEval.where(user_id: user.id).includes(:user).sort.reverse
      if !@preceptor_evals.empty?
        @student_name = @preceptor_evals.first.user.full_name
        preceptor_evals_hash = @preceptor_evals.map(&:attributes)
      end
    end
    respond_to do |format|
      format.html
    end
  end

end
