class CoursesController < ApplicationController
  layout 'full_width_margins'
  before_action :authenticate_user!

  def index
    @courses = Course.where(competency_code: params[:competency_code].upcase)

  end
end
