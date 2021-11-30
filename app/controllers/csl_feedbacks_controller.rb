class CslFeedbacksController < ApplicationController
  layout 'full_width_csl'
  before_action :authenticate_user!
  before_action :set_resources
  respond_to :json, :html

  def index
   if current_user.coaching_type == "student"
     @coaches.push  current_user.cohort.owner
     @csl_feedbacks = CslFeedback.where(user_id: current_user.id).order(:submit_date)
   elsif current_user.coaching_type == "coach"
     @cohort_students = current_user.cohorts.where("title like ?", "%#{session[:cohort]}%").first.users.order('full_name ASC')
     @csl_feedbacks = CslFeedback.where(user_id: @cohort_students[0].id).order(:submit_date)
   else
     # @students = CslFeedback.where(cohorts: session[:cohort]).includes(:owner).all
     # @cohort_students = @students.map(&:owner).uniq.sort_by{|c| c.full_name}
     @csl_feedbacks = CslFeedback.where(user_id: params[:user_id]).order(:submit_date)
    end
    if request.xhr?
      respond_to do |format|
        format.json {
          render json: {cohort_students: @cohort_students}
        }
        format.html
      end
    end
  end

  def get_csl_feedback
    @csl_feedbacks = CslFeedback.where(user_id: params[:user_id])
    if request.xhr?
      respond_to do |format|
        format.js   {render layout: false}
        #format.json {render json: {csl_feedacks: @csl_feedbacks}}
      end
    end
  end

  private
  def set_resources
    @coaches = []
    @cohort_students = []
    @csl_feedbacks = []

  end
end
