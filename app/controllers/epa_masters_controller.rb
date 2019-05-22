class EpaMastersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_epa_master, only: [:show, :edit, :update]
  before_action :set_resources, only: [:show]
  include EpaMastersHelper

  def get_index
    @epa_masters = EpaMaster.where(user_id: @selected_user_id).order(:id)
    if @epa_masters.empty?
      create_epas @selected_user_id
      @epa_masters = EpaMaster.where(user_id: @selected_user_id).order(:id)
    end

    render :index

  end

  # GET /epa_masters
  def index
   @student_groups = hf_student_groups
   if params[:search]
     @selected_user = nil
     @users = User.where("full_name LIKE ? ", "%#{params[:search]}%")
     if !@users.empty?
       @epa_masters = @users.first.epa_masters.order(:id)
       @full_name = @users.first.full_name
       hf_check_for_auto_badging(@users.first.id)
       if @epa_masters.empty?
         user_id = @users.first.id
         create_epas user_id
         @epa_masters = EpaMaster.where(user_id: user_id).order(:id)
       end
     end
     respond_to do |format|
       format.js { render partial: 'search-results'}
     end
   elsif params[:email].present?
      @selected_user = User.find_by(email: params[:email])
      @selected_user_id = @selected_user.id
      @full_name = @selected_user.full_name
      #@epa_reviews = EpaReview.find_by(epa_masters_id: params[:epa_masters_id])
      get_index
    elsif params[:id].present?
      @selected_user_id = @epa_master.user_id
      @full_name = User.find(@epa_master.user_id).full_name
      #@epa_reviews = EpaReview.find_by(epa_masters_id: params[:epa_masters_id])
      get_index
    end
  end

  def export_data
    if params[:permission_group_id].present?
        EpaMaster.export_data_delimited(params[:permission_group_id])
        @file_name = Rails.root + "tmp/chungp_epas.txt"
        send_file(@file_name, filename: @file_name,  type: 'application/pdf/text/docx/doc', :disposition=>'inline', :target=>"_blank")
        byebug
    end
  end

  def new_master
    @epa_master = EpaMaster.new
    #flash[:notice] = '** You need to select a student first! ***'
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
    end
  end

  # GET /epa_masters/1
  def show
    if params[:userid].present?
    end
  end

  # GET /epa_masters/new
  def new
    if params[:user_id].present?
      @selected_user_id = params[:user_id].to_i
    elsif params[:email].present?
      @selected_user = User.find_by(email: params[:email])
      @selected_user_id = @selected_user.id
    end
    @epa_master = EpaMaster.new
    @epa_master.user_id = @selected_user_id

    render :new
      # respond_to do |format|
      #   format.html
      #   format.js
      # end
  end

  # GET /epa_masters/1/edit
  def edit
    @epa_master = EpaMaster.find(params[:id])
    @selected_user_id = @epa_master.user_id
    @full_name = User.find(@epa_master.user_id).full_name
    respond_to do |format|
      format.html
      format.js {render template: 'epa_masters/epa_master_modal.js.erb'}
    end

  end

  def get_by_user
    @student_groups = hf_student_groups
    @selected_user_id = params[:user_id]
    @epa_masters = EpaMaster.where(user_id: @selected_user_id).order(:id)
    get_index
    if @epa_masters.empty?
      create_epas @selected_user_id
      @epa_masters = EpaMaster.where(user_id: @selected_user_id).order(:id)
    end
    if request.xhr?
      respond_to do |format|
        format.js { render action: 'get_by_user', status: 200 }
      end

    else
      respond_to do |format|
        format.html
      end
    end

  end

  # POST /epa_masters
  def create
     @epa_master = EpaMaster.new(epa_master_params)

    if @epa_master.save
      redirect_to @epa_master, notice: 'Epa master was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /epa_masters/1
  def update
    if @epa_master.update(epa_master_params)
      #redirect_to @epa_master, notice: 'Epa master was successfully updated.'
      @selected_user_id = @epa_master.user_id

      index
    else
      render :edit
    end
  end

  # DELETE /epa_masters/1
  def destroy
    @epa_master.destroy
    redirect_to epa_masters_url, notice: 'Epa master was successfully destroyed.'
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_epa_master
      @selected_user_id = EpaMaster.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def epa_master_params
      params.require(:epa_master).permit(:user_id, :epa,
        :status, :status_date, :expiration_date )
    end

    def create_epas selected_user_id
      for i in 1..13 do
        EpaMaster.where(user_id: selected_user_id, epa: "EPA#{i}").first_or_create do |epa|
          epa.user_id = selected_user_id
          epa.epa = "EPA#{i}"
        end
      end


    end
end
