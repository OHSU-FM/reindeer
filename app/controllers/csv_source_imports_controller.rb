class CsvSourceImportsController < ApplicationController
  def new
    @csv_source_import = CsvSourceImport.new
  end

  def create
    @csv_source_import = CsvSourceImport.new(params[:csv_source_import])
    if @csv_source_import.save
      redirect_to csv_sources_path, notice: 'Imported successfully'
    else
      render :new
    end
  end
end
