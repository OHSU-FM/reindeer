class CsvSourcesController < ApplicationController
  def index
    @csv_sources = CsvSource.all
    respond_to do |format|
      format.html
      format.csv { send_data @csv_sources.to_csv }
    end
  end
end
