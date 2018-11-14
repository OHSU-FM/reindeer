class ArtifactsController < ApplicationController
  layout 'full_width_margins'
  before_action :set_artifact, only: [:show, :edit, :update, :destroy, :move]


  # GET /artifacts
  def index
    if !params[:user_id].nil?
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
  end

  # GET /artifacts/1/edit
  def edit
  end

  # POST /artifacts
  def create
    @artifact = Artifact.new(artifact_params)
    @artifact.user_id = current_user.id
    if @artifact.save
      redirect_to @artifact, notice: 'Artifact was successfully created.'
    else
      render :new
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
    @artifact = Artifact.find(@artifact_document.attachments.first.record_id)
    @artifact_document.attachments.first.purge
     redirect_to artifacts_url

  end

  def move_files
    @artifact = Artifact.find(params[:id])
    move_file_to_user(@artifact)
  end

  private

    def move_file_to_user(artifact)

      artifact.documents.each do |document|

        #artifact_document = document.id #ActiveStorage::Blob.find_signed(params[:id])
        full_name = document.filename.to_s.split(" ").first.gsub("_", ", ")
        @student_user = User.find_by(full_name: full_name)
        if !@student_user.nil?
          temp_artifact = Artifact.find_or_create_by(user_id: @student_user.id, content: artifact.content, title: artifact.title)
          temp_artifact.documents.attach(ActiveStorage::Blob.find(document.blob_id))
          document.destroy # remove it from the artifact
          byebug
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
