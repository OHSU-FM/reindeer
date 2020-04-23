class CslFeedbacksController < ApplicationController
  layout 'full_width_csl'
  before_action :authenticate_user!
  before_action :set_resources
  respond_to :json, :html

  def index

   if current_user.coaching_type == "student"
     #@cohort_students.push current_user
     @coaches.push  current_user.cohort.owner
     @csl_feedbacks = CslFeedback.where(user_id: current_user.id).order(:submit_date)

   elsif current_user.coaching_type == "coach"
     #@coaches.push current_user
     @cohort_students = current_user.cohorts.where("title like ?", "%#{params[:cohort]}%").first.users.order('full_name ASC')
     @csl_feedbacks = CslFeedback.where(user_id: @cohort_students[0].id).order(:submit_date)
     #@cohort_students = Cohort.where("user_id = ? and title LIKE ?", current_user.id, "%#{params[:cohort]}%").first.users.order('full_name ASC')
   else
     @students = CslFeedback.where(cohorts: params[:cohort]).includes(:owner).all
     @cohort_students = @students.map(&:owner).uniq!.sort_by{|c| c.full_name}
     @csl_feedbacks = CslFeedback.where(user_id: params[:user_id]).order(:submit_date)
      # removed the coach category
      # if params[:coach_id].present?
      #   byebug
      #   @cohort_students = User.where(id: params[:coach_id]).first.cohorts.where("title like ?", "%#{params[:cohort]}%").first.users
      # #  @cohort_students = User.select(:id, :full_name).where(permission_group_id: params[:permission_group_id]).order(:full_name)
      # end
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

  def show

  end

  private
  def set_resources
    @coaches = []
    @cohort_students = []
    @csl_feedbacks = []
    if current_user.dean_or_higher?

        # @students = CslFeedback.where(cohorts: params[:cohort]).includes(:owner).all
        # @cohort_students = @students.map(&:owner).uniq!.sort_by{|c| c.full_name}
        # @csl_feedbacks = CslFeedback.where(user_id: @cohort_students.first.id)
        #@students = @cohorts.map(&:users).flatten
      end


  end
end
