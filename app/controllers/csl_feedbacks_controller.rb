class CslFeedbacksController < ApplicationController
  layout 'full_width_csl'
  before_action :authenticate_user!
  before_action :set_resources

  def index

   if current_user.coaching_type == "student"
     @cohort_students = current_user
     @coaches = current_user.cohort.owner

   elsif current_user.coaching_type == "coach"
     @cohort_students = Cohort.where("user_id = ? and title LIKE ?", current_user.id, "%#{params[:cohort]}%").first.users.order('full_name ASC')
   else
      @cohort_students = []
      if params[:coach_id].present?
        @cohort_students = User.where(id: params[:coach_id]).first.cohorts.where("title like ?", "%Med22%").first.users
      #  @cohort_students = User.select(:id, :full_name).where(permission_group_id: params[:permission_group_id]).order(:full_name)
      end
    end
    if request.xhr?
      respond_to do |format|
        format.json {
          render json: {cohort_students: @cohort_students}
        }
      end
    end

    # @permission_id = PermissionGroup.where("title LIKE ?", "%#{params[:cohort]}%").first.id
    # if current_user.coaching_type == "coach"
    #   @students = Cohort.where("user_id = ? and title LIKE ?", current_user.id, "%#{params[:cohort]}%").first.users.order('full_name ASC')
    #   students_array = @students.map{|s| s.id}
    # elsif current_user.coaching_type == "student"
    # else
    #   @students = User.where(permission_group_id: @permission_id, coaching_type: 'student').order('full_name ASC')
    # end
    #
    # if params[:user_id].present?
    #   @csl_feedbacks = CslFeedback.where(user_id: params[:user_id])
    # elsif params[:email].present?
    #   @csl_feedbacks = User.where(email: params[:email]).first.csl_feedbacks.where(cohorts: params[:cohort])
    # elsif current_user.coaching_type == 'coach'
    #       @csl_feedbacks = CslFeedback.where("cohorts = ? and csl_title like ? and user_id in (?) ", params[:cohort], "%#{params[:block]}%", students_array)
    # else
    #   @csl_feedbacks = CslFeedback.where("cohorts = ? and csl_title like ? ", params[:cohort], "%#{params[:block]}%")
    # end
    #
    # @cohorts = current_user.cohorts

  end

  def show

  end
  private
  def set_resources
      #@student = User.find_by_username(params[:slug])
      # @student = User.where("username = ?", params[:slug]).first
      # @@student_g = @student
      #
      # @csl_feedbacks = @student.csl_feedacks
      if current_user.coach?
        @cohorts = current_user.cohorts.where("title NOT LIKE ?", "%Med18%").order('title DESC')
        @coaches = @cohorts.map(&:owner).uniq!
        @cohort_students = current_user.cohorts.where("title like ?", "%Med22%").first.users
        byebug
      #  @cohort_students = User.select(:id, :full_name).where(permission_group_id: params[:permission_group_id]).order(:ful
      elsif current_user.dean_or_higher?
        @cohorts = Cohort.includes(:users).includes(:owner).all
        @coaches = @cohorts.map(&:owner).uniq!
        @students = @cohorts.map(&:users).flatten
      end


  end
end
