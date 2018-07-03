class SearchesController < ApplicationController
  layout 'full_width_margins'
  def search

    if params[:search].blank?
      redirect_to(root_path, alert: "Empty field!") and return
    elsif current_user.coaching_type == 'coach'
        coach_search
    elsif
      @parameter = params[:search].downcase + "%"
      @results = User.all.where("lower(full_name) LIKE :search", search: @parameter)

    end
  end

  def coach_search
    @results = []
    @parameter = params[:search].downcase
    cohorts = current_user.cohorts
    cohorts.each do |cohort|
      cohort.users.each do |user|
        if @parameter == "*"
          @results.push user
        elsif user.full_name.downcase.include? @parameter
          @results.push user
        end
      end
    end
  end
end
