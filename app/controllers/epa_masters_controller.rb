class EpaMastersController < ApplicationController
  layout 'full_width_csl'
  before_action :authenticate_user!
  before_action :set_epa_master, only: [:show, :edit, :update, :destroy]
  include EpaMastersHelper

  # GET /epa_masters
  def index
    @eg_cohorts ||= hf_load_eg_cohorts (current_user.email)
    if params[:search].present?
      @selected_user = nil
      @parameter = params[:search].downcase
      #@results = User.where("lower(full_name) LIKE :search", search: @parameter)
      @users = User.where("lower(full_name) LIKE ? and coaching_type = ? ", "%#{@parameter}%", "student")
      if !@users.empty? and @users.count == 1
        @epa_masters = @users.first.epa_masters.order(:id)
        @full_name = @users.first.full_name
        if @epa_masters.empty?
          user_id = @users.first.id
          email = @users.first.email
          create_epas user_id, email
          @epa_masters = EpaMaster.where(user_id: user_id).order(:id)
        end
      end
      respond_to do |format|
        format.js { render partial: 'search-results' and return}
        format.html
      end
    elsif params[:user_id].present?
      @user = User.find(params[:user_id])
      load_epa_masters
    elsif params[:email].present?
      @user = User.find_by(email: params[:email])
      load_epa_masters
    end


  end

  def load_epa_masters
    @epa_masters = @user.epa_masters.order(:id)
    @full_name = @user.full_name
    if @epa_masters.empty?
      create_epas @user.id, @user.email
      @epa_masters = EpaMaster.where(user_id: @user.id).order(:id)
    end

    respond_to do |format|
      format.html
      format.js { render partial: 'search-results' and return}
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

  def eg_report

    if params[:eg_member].present?
      @epa_masters = EpaMaster.where("status is NULL and epa = ?", params[:epa]).order(:user_id).includes(:user)

        respond_to do |format|
          format.html
        end
     end
     render :eg_report

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

  def create_epas selected_user_id, email
    eg_full_name1, eg_full_name2 = hf_get_eg_members(@eg_cohorts, email)

    for i in 1..13 do
      epa_master = EpaMaster.where(user_id: selected_user_id, epa: "EPA#{i}").first_or_create do |epa|
        epa.user_id = selected_user_id
        epa.status = 'Not Yet'
        epa.epa = "EPA#{i}"
      end
      epa_master.epa_reviews.where(epa: epa_master.epa).first_or_create do |review|
        review.epa = epa_master.epa
        review.review_date1 = DateTime.now
        review.badge_decision1 = "Not Yet"
        review.reason1 = "Required at least 3 MSPE comments or at least 4 WBAs with level 4"
        review.badge_decision2 = "Not Yet"
        review.reason2 = "Required at least 3 MSPE comments or at least 4 WBAs with level 4"
        review.reviewer1 = eg_full_name1
        review.reviewer2 = eg_full_name2
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


end
