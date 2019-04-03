class EpaMastersController < ApplicationController
  before_action :set_epa_master, only: [:show, :edit, :update, :destroy]

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

    if params[:email].present?
      @selected_user = User.find_by(email: params[:email])
      @selected_user_id = @selected_user.id
      @full_name = @selected_user.full_name
      get_index
    elsif params[:user_id].present?
      @selected_user_id = params[:user_id]
      get_index
    elsif params[:id].present?
      @selected_user_id = @epa_master.user_id
      @full_name = User.find(@epa_master.user_id).full_name
      get_index
    else
      flash[:notice] = '** You need to select a student first! ***'

    end

  end

  # GET /epa_masters/1
  def show
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
      @epa_master = EpaMaster.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def epa_master_params
      params.require(:epa_master).permit(:user_id, :epa,
        :review_date1, :reviewed_by1a, :reviewed_by1b, :note1, :status1,
        :review_date2, :reviewed_by2a, :reviewed_by2b, :note2, :status2,
        :review_date3, :reviewed_by3a, :reviewed_by3b, :note3, :status3 )
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
