class EpaMastersController < ApplicationController
  layout 'full_width_csl'
  before_action :authenticate_user!
  before_action :set_epa_master, only: [:show, :edit, :update, :destroy]

  # GET /epa_masters
  def index
    if params[:search]
      @selected_user = nil
      @users = User.where("full_name LIKE ? and coaching_type = ? ", "%#{params[:search]}%", "student")


      if !@users.empty? and @users.count == 1
        @epa_masters = @users.first.epa_masters.order(:id)
        @full_name = @users.first.full_name
        if @epa_masters.empty?
          user_id = @users.first.id
          create_epas user_id
          @epa_masters = EpaMaster.where(user_id: user_id).order(:id)
        end
      end
      respond_to do |format|
        format.js { render partial: 'search-results'}
        format.html
      end
    end
  end

  # GET /epa_masters/1
  def show
  end

  # GET /epa_masters/new
  def new
    @epa_master = EpaMaster.new
  end

  # GET /epa_masters/1/edit
  def edit
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


  def search_student
    if params[:search]
      @selected_user = nil
      @users = User.where("full_name LIKE ? and coaching_type = ? ", "%#{params[:search]}%", "student")
      if !@users.empty?
        @epa_masters = @users.first.epa_masters.order(:id)
        @full_name = @users.first.full_name
        if @epa_masters.empty?
          user_id = @users.first.id
          create_epas user_id
          @epa_masters = EpaMaster.where(user_id: user_id).order(:id)
        end
      end
      respond_to do |format|
        format.js { render partial: 'search-results'}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_epa_master
      @epa_master = EpaMaster.find(params[:id])
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
