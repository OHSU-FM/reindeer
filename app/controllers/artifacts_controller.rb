class ArtifactsController < ApplicationController
  layout 'full_width_margins'
  before_action :set_artifact, only: [:show, :edit, :update, :destroy, :move]


  # GET /artifacts
  def index
    if !params[:user_id].nil?
      @user_id = params[:user_id]
      @artifacts = Artifact.where(user_id: params[:user_id])
    else
      @artifacts = Artifact.where(user_id: current_user.id)
    end
  end

  # GET /artifacts/1
  def show
  end

  # GET /artifacts/new
  def new
    @artifact = Artifact.new
    @student_groups = PermissionGroup.select(:id, :title).where("title Like ?", "%Students%").order(:title)
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

  private

    def move_file_to_user(artifact)

      artifact.documents.each do |document|
        #artifact_document = document.id #ActiveStorage::Blob.find_signed(params[:id])
        temp_str = document.filename.to_s.split(" ")
        temp_str2 = temp_str.first.split("_")
        if temp_str2.count >= 2
           full_name = temp_str2.first + ", " + temp_str2.second
        else
           return
         end
      
        #filename = document.filename.to_s.gsub("_", ", ")

        #full_name = temp_str.first + ", " + temp_str.second

        @student_user = User.find_by(full_name: full_name)
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

    # Use callbacks to share common setup or constraints between actions.
    def set_artifact
      @artifact = Artifact.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def artifact_params
      params.require(:artifact).permit(:title, :content, :user_id, documents: [])
    end
end
