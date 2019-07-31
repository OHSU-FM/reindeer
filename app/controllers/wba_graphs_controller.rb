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

    @chart = hf_series_data

  end
end
