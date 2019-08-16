class WbaGraphsController < ApplicationController
  include WbaGraphsHelper
  layout 'full_width_csl'
  before_action :authenticate_user!


  def index

    #
    # @wba = Epa.all
    # @epa = @wba.group(:epa).count.sort_by{|k,v| v}.reverse
    # #@categories = @epa.map{|k,v| k}
    # @data = @epa.map{|k,v| v}

    if params[:category_id].present?
      @chart = hf_series_data(params[:category_id])
    else
      @chart = hf_series_data('EPA')
    end
    @most_fours, @total_count_fours = most_fours
    @most_ones, @total_count_ones = most_ones

  end

  def show
  end

  private
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


end
