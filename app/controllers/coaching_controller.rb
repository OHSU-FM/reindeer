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
        redirect_to coaching_student_path(current_user.cohorts.first.users.first)
      end
    elsif current_user.dean? || current_user.admin_or_higher?
      if !email.nil?
        selected_student = User.find_by(email: email)
        redirect_to coaching_student_path selected_student
      else
        redirect_to coaching_student_path Coaching::Goal.last.user
      end
    else
      redirect_to root_path
    end
  end
end
