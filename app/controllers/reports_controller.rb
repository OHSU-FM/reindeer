class ReportsController < ApplicationController
  layout 'full_width_csl'
  protect_from_forgery prepend: true, with: :exception
  before_action :authenticate_user!, :set_resources
  include ReportsHelper

  def index
    if params[:cohort].present?
      @users = User.where(permission_group_id: params[:cohort]).select(:id, :full_name, :username, :email).order(:full_name)
      @cohort_title = PermissionGroup.find(params[:cohort]).title.scan(/\((.*)\)/).first.first
      @ranking_data = hf_get_ranking(@users)
      create_file @ranking_data, "#{@cohort_title}_ranking_data.txt"
    end
    respond_to do |format|
      format.html
    end

  end

  def download_file
      if params[:file_name].present?
        private_download params[:file_name]

      end
  end

  private

  def set_resources
    @permission_groups = PermissionGroup.last(3) # get last 3 rows
  end

  def private_download in_file
     send_file  "#{Rails.root}/tmp/#{in_file}", type: 'text', disposition: 'download'
  end

  def create_file (in_data, in_file)
    file_name = "#{Rails.root}/tmp/#{in_file}"

    CSV.open(file_name,'wb', col_sep: "\t") do |csvfile|
      csvfile << in_data.first.keys.map{|c| c.titleize}
      in_data.each do |row|
        csvfile << row.values
      end
    end
  end


end
