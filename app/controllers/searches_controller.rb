class SearchesController < ApplicationController
  include SearchesHelper
  layout 'full_width_height_margins'

  def search

    if params[:search].blank?
      redirect_to(root_path, alert: "Empty field! - Please Enter Something!") and return
    elsif current_user.coaching_type == 'coach'
        coach_search
    elsif !params[:search].downcase.include? "med18"
      @parameter = params[:search].downcase + "%"
      @results = User.where("lower(full_name) LIKE :search", search: @parameter)
    else
      @student_year = hf_student_year(params[:search])
      @class_comp = Competency.order('student_name').where(student_year: @student_year).page(params[:page])

      if @class_comp.empty?
        redirect_to(root_path, alert: "No records found for #{params[:search]}")
      else
        @class_mean_exist = true
        @clinical_sid = hf_dataset_sid(params[:search])
      end
    end
    # respond_to do |format|
    #   format.js { render partial: 'search-results'}
    # end
  end

  private

  def load_all_students cohorts
    cohorts.each do |cohort|
        cohort.users.each do |user|
          @results.push user
        end
      end
  end

  def coach_search
    @results = []
    @parameter = params[:search].downcase
    cohorts = current_user.cohorts
    if @parameter == "*"
      load_all_students(cohorts)
    else
      cohorts.each do |cohort|
        # Looking for med18, med19, etc in the title
        if cohort.title.downcase.include? @parameter
          cohort.users.each do |user|
            @results.push user
          end
        end
      end
    end
  end
end
