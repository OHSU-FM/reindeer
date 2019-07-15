class CdsReportsController < ApplicationController
  include CdsReportsHelper
  layout 'full_width_margins'

  def index
    @cds = hf_cds_reporting
  end
end
