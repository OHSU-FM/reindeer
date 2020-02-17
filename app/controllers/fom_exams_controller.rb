class FomExamsController < ApplicationController
  include FomExamsHelper

  def index
    @artifacts = Artifact.where(user_id: params[:user_id])
  end

  def process_csv
    # @artifacts.first.documents.first.download --> works
    @log_results = FomExam.process_file(params[:attach_id])
  end

  def display_fom
    @course_code = params[:course_code]
    if current_user.admin_or_higher?
       permission_group_id  = 17 # cohort Med23
       @comp1_quizzes, @comp_avg_quizzes,  @exam_headers = FomExam.exec_raw_sql(params[:attach_id], permission_group_id )

    end

    respond_to do |format|
      format.html
    end
  end

 private




end
