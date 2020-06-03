class StudentAssessmentsController < ApplicationController
  layout 'full_width_csl'
  before_action :authenticate_user!
  respond_to :html, :json

  def show

    render :show
    if request.xhr?
      respond_to do |format|
        format.json {
          render json: {cohort_students: @cohort_students}
        }
      end
    end
  end


end
