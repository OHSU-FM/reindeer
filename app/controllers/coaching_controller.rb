# this checks the coaching_type of the user and redirects to the
# appropriate place
class CoachingController < ApplicationController
  def index
    if current_user.student?
      redirect_to coaching_student_path(current_user)
    elsif current_user.coach?
      redirect_to coaching_student_path(current_user.cohorts.first.users.first)
    elsif current_user.dean?
      redirect_to coaching_student_path Goal.last.user
    end
  end
end
