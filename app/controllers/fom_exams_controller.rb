class FomExamsController < ApplicationController

  def index
    @artifacts = Artifact.where(user_id: params[:user_id])
  end

  def process_csv
    # @artifacts.first.documents.first.download --> works
    @log_results = FomExam.process_file(params[:attach_id])
  end

 private




end
