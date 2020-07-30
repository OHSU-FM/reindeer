class FomExamsController < ApplicationController
  before_action :authenticate_user!
  include FomExamsHelper
  include ArtifactsHelper

  def index
    @artifacts = Artifact.where(user_id: params[:user_id])
  end

  def list_all_blocks
    @list_all_blocks = FomExam.distinct.pluck(:permission_group_id, :course_code).sort
    respond_to do |format|
      format.html
    end
  end

  def export_block
    if params[:permssion_group_id].present? and params[:course_code].present?
      @export_block = FomExam.includes(:user_only_fetch_email).where(permission_group_id: params[:permssion_group_id], course_code: params[:course_code])
      send_data @export_block.to_csv,  filename: 'export_block.csv', disposition: 'download'
    end
    respond_to do |format|
      format.html
    end
  end

  def process_csv
    # @artifacts.first.documents.first.download --> works
    if !hf_check_label_file(params[:attach_id])
      @log_results = FomExam.process_file(params[:attach_id])
    end

  end

  def display_fom
    @course_code = params[:course_code]
    if params[:permission_group_id].present? and params[:user_id].present?  #current_user.admin_or_higher?
       #permission_group_id  = 17 # cohort Med23
       @comp_keys = FomExam.comp_keys
       student  = User.find(params[:user_id])
       @student_email = student.email
       @student_full_name = student.full_name
       @coach_info = student.cohort.nil? ? "Not Assigned" : student.cohort.title
       @block_desc = hf_get_block_desc(params[:course_code])
       @student_uid = student.sid
       @comp_exams, @comp_avg_exams,  @exam_headers = FomExam.exec_raw_sql(params[:user_id], params[:attach_id], params[:permission_group_id], params[:course_code] )

       @failed_comps = hf_scan_failed_score(@comp_exams)
       block_code = @course_code.split("-").second  #course_code format '1-FUND', '2-BLHD', etc
       @artifacts_student_fom, @no_official_docs, @shelf_artifacts = hf_get_fom_artifacts(@student_email, "FoM", block_code)

    end

    respond_to do |format|
      format.html
    end
  end

 private

end
