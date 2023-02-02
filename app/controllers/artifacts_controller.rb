class ArtifactsController < ApplicationController
  layout 'full_width_margins'
  before_action :authenticate_user!
  before_action :set_artifact, only: [:show, :edit, :update, :destroy, :move]

  include ArtifactsHelper


  # GET /artifacts
  def index
    if !params[:uuid].nil?
      user = User.find_by(uuid: params[:uuid])
      if (hf_file_visible("Mock Step 1") == true)
        @artifacts = User.find_by(uuid: params[:uuid]).artifacts   #Artifact.where(user_id: user.id)
      else
          #@artifacts = Artifact.where("user_id = ? and content not like ?", user.id, "%Mock%")
          @artifacts = User.find_by(uuid: params[:uuid]).artifacts.where("content not like ?", "%Mock%")
      end
    else
      @artifacts = User.find_by(id: current_user.id).artifacts
    end
  end

  # GET /artifacts/1
  def show
  end

  # GET /artifacts/new
  def new
    @artifact = Artifact.new
    @student_groups = PermissionGroup.select(:id, :title).where(" id >= ? and id <> ?", 16, 15).order(:title)
    @cohort_students = []
    if params[:permission_group_id].present?
      @cohort_students = User.select(:id, :full_name).where(permission_group_id: params[:permission_group_id]).order(:full_name)
    end
    if request.xhr?
      respond_to do |format|
        format.json {
          render json: {cohort_students: @cohort_students}
        }
      end
    else
      respond_to do |format|
        format.html
      end
    end

  end

  # GET /artifacts/1/edit
  def edit
  end

  # POST /artifacts
  def create
    @artifact = Artifact.new(artifact_params)
    if params[:user_id].present?
      @artifact.user_id = params[:user_id].to_i
    else
      @artifact.user_id = current_user.id
    end

    if @artifact.save
      redirect_to @artifact, notice: 'Artifact was successfully created.'
    else
      redirect_to @artifact, notice: 'Error Invalid File Type - only allowed PDF, JPEG, JPG & PNG!'

    end
  end

  # PATCH/PUT /artifacts/1
  def update
    if @artifact.update(artifact_params)
      redirect_to @artifact, notice: 'Artifact was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /artifacts/1
  def destroy
    @artifact.destroy
    redirect_to artifacts_url, notice: 'Artifact was successfully destroyed.'
  end

  def delete_document_attachment
    @artifact_document = ActiveStorage::Blob.find_signed(params[:id])
    #@artifact = Artifact.find(@artifact_document.attachments.first.record_id)
    @artifact_document.attachments.first.purge
    redirect_to artifacts_url, notice: 'Document was successfully purged!'

  end

  def move_files
    @artifact = Artifact.find(params[:id])
    move_file_to_user(@artifact)
  end

  def step_2_move_files
    @artifact = Artifact.find(params[:id])
    step2_move_files_to_user(@artifact)
  end

  def process_preceptor_eval
    @artifact = Artifact.find(params[:id])
    @log_results = Artifact.process_upload_data(@artifact, 'PreceptorEval')
  end

  def process_formative_feedback
    @artifact = Artifact.find(params[:id])
    @log_results = Artifact.process_upload_data(@artifact, 'FormativeFeedback')
  end

  def process_comp_excel
    @artifact = Artifact.find(params[:id])
    Artifact.read_competency_excel(@artifact)
    todayDate = Time.now.strftime("%Y_%m_%d")
    filename = "#{Rails.root}/log/competency_#{todayDate}.log"
    render file: filename
  end

  private

    def move_file_to_user(artifact)

      artifact.documents.each do |document|
        #artifact_document = document.id #ActiveStorage::Blob.find_signed(params[:id])
        if !document.filename.to_s.include? "image00"  ## check to see if it is an image file from informatics feedback so that we can move to it
          temp_str = document.filename.to_s.split(" ")
          if temp_str.last.include? "Preceptorship"
            full_name = temp_str[0] + " " + temp_str[1]
          else
            temp_str2 = temp_str.first.split("_")
            if temp_str2.count == 1
               last_name = temp_str2.first
               temp_str3 = temp_str.second.split("_")
               last_name = last_name + " " + temp_str3.first
               first_name = temp_str3.second
               full_name = last_name + ", " + first_name
            elsif temp_str2.count >= 2
               full_name = temp_str2.first + ", " + temp_str2.second
            else
               return
             end
           end
          @student_user = User.find_by(full_name: full_name)
        else
          username = document.filename.to_s.split("_").first
          @student_user = User.find_by(username: username)
        end

        if !@student_user.nil?
          temp_artifact = Artifact.find_or_create_by(user_id: @student_user.id, content: artifact.content, title: artifact.title) do |a|
            a.content = artifact.content
            a.title = artifact.title
            a.documents.attach(ActiveStorage::Blob.find(document.blob_id))
          end
          if !temp_artifact.documents.exists?(blob_id: document.blob_id)
             temp_artifact.documents.attach(ActiveStorage::Blob.find(document.blob_id))
          end
          document.destroy # remove it from the artifact
        end
      end
    end

    def step2_move_files_to_user(artifact)
      nbme_match_file = "#{Rails.root}/config/Med26_NBME_Name_Match.txt"
      row_hash = {}
      CSV.foreach(nbme_match_file, col_sep: "\t", :headers => true, encoding: "UTF-8") do |row|
        row_hash.store(row["pdf_file"], row["email"])
      end
      artifact.documents.each do |document|
        email = row_hash[document.filename.to_s]
        student_user = User.find_by(email: email)
        if !student_user.nil?
          temp_artifact = Artifact.find_or_create_by(user_id: student_user.id, content: artifact.content, title: artifact.title) do |a|
            a.content = artifact.content
            a.title = artifact.title
            a.documents.attach(ActiveStorage::Blob.find(document.blob_id))
          end
          if !temp_artifact.documents.exists?(blob_id: document.blob_id)
             temp_artifact.documents.attach(ActiveStorage::Blob.find(document.blob_id))
          end
          document.destroy # remove it from the artifact
        end
      end

    end

    # Use callbacks to share common setup or constraints between actions.
    def set_artifact
      @artifact = Artifact.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def artifact_params
      params.require(:artifact).permit(:title, :content, :user_id, documents: [])
    end
end
