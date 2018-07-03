class SearchesController < ApplicationController
  layout 'full_width_margins'
  def search

    if params[:search].blank?
      redirect_to(root_path, alert: "Empty field!") and return
    else
      @parameter = params[:search].downcase + "%"
      @results = User.all.where("lower(full_name) LIKE :search", search: @parameter)

    end
  end
end
