# this checks the coaching_type of the user and redirects to the
# appropriate place
class CoachingController < ApplicationController
  def index
     email = params[:email]
    if current_user.student?
      redirect_to coaching_student_path(current_user)
    elsif current_user.coach?
      if !email.nil?
        selected_student = User.find_by(email: email)
        redirect_to coaching_student_path selected_student
      else
        student = current_user.cohorts.where("title not like ?", "%Med18%").order(title: :desc).first.users.first
        ## orig code --> current_user.cohorts.first.users.first
        redirect_to coaching_student_path(student)
      end
    elsif current_user.dean? or current_user.admin_or_higher?
      if !email.nil?
        selected_student = User.find_by(email: email)
        redirect_to coaching_student_path selected_student
      else
        redirect_to coaching_student_path Coaching::Meeting.last.user
      end
    else
      #byebug
      redirect_to root_path
    end
  end
end
