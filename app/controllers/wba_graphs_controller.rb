class WbaGraphsController < ApplicationController
  layout 'full_width_csl'
  before_action :authenticate_user!
  before_action :set_resources
  include WbaGraphsHelper
  include EpasHelper
  include EpaMastersHelper
  include EpaReviewsHelper

  def index
    if params[:category_id].present?
      @chart = hf_series_data(params[:category_id])
    elsif params[:email].present?
        puts "it has email: " + email
    end
    @most_fours, @total_count_fours = most_fours
    @most_ones, @total_count_ones = most_ones
    respond_to do |format|
      format.html
    end
    #@med21_cohort = User.select(:email, :full_name).where(permission_group_id: 13).order(:full_name)
  end

  def wba_report

    if params[:permission_group_id].present?
      @wba_report = User.where(permission_group_id: params[:permission_group_id]).order(:full_name).includes(:epas)
      create_file @wba_report, "wba_report.txt"
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

  def private_download in_file
    send_file  "#{Rails.root}/tmp/#{in_file}", type: 'text', disposition: 'download'
  end

  def most_fours
    array_fours ||= Epa.where(involvement: 4).select(:involvement).group(:assessor_name).count
    sorted = array_fours.sort_by{|k,v| v}.reverse
    total_count_fours = Epa.where(assessor_name: "#{sorted[0].first}").count
    return sorted[0], total_count_fours
  end

  def most_ones
    array_fours ||= Epa.where(involvement: 1).select(:involvement).group(:assessor_name).count
    sorted = array_fours.sort_by{|k,v| v}.reverse
    total_count_ones = Epa.where(assessor_name: "#{sorted[0].first}").count
    return sorted[0], total_count_ones
  end

  def set_resources
        # @permission_groups = PermissionGroup.where('id >= ? and id <= ?', 16, 20)  #greater than med22 for preceptorship WBA and <= Med26 cohort
        @permission_groups = PermissionGroup.where('id >= ? ',16)  #greater than med22 for preceptorship WBA and <= Med26 cohort

  end

  def create_file (in_data, in_file)
    file_name = "#{Rails.root}/tmp/#{in_file}"
    CSV.open(file_name,'wb', col_sep: "\t") do |csvfile|
      csvfile << Epa.column_names.map{|c| c.titleize}
      in_data.each do |user|
        user.epas.each do |epa|
          csvfile << epa.attributes.values
        end
      end
    end
  end


end
