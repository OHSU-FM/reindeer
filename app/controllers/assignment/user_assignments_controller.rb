class Assignment::UserAssignmentsController < ApplicationController
  def index
    @user_assignments = Assignment::UserAssignment.where(user_id: current_user.id)
  end

  def show
  end

  def new
    @user_assignment = Assignment::UserAssignment.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
