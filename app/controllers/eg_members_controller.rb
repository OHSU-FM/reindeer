class EgMembersController < ApplicationController
  before_action :set_eg_member, only: %i[ show edit update destroy ]

  # GET /eg_members or /eg_members.json
  def index
    @eg_members = EgMember.all
  end

  # GET /eg_members/1 or /eg_members/1.json
  def show
  end

  # GET /eg_members/new
  def new
    @eg_member = EgMember.new
  end

  # GET /eg_members/1/edit
  def edit
  end

  # POST /eg_members or /eg_members.json
  def create
    @eg_member = EgMember.new(eg_member_params)

    respond_to do |format|
      if @eg_member.save
        format.html { redirect_to eg_member_url(@eg_member), notice: "Eg member was successfully created." }
        format.json { render :show, status: :created, location: @eg_member }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @eg_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /eg_members/1 or /eg_members/1.json
  def update
    respond_to do |format|
      if @eg_member.update(eg_member_params)
        format.html { redirect_to eg_member_url(@eg_member), notice: "Eg member was successfully updated." }
        format.json { render :show, status: :ok, location: @eg_member }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @eg_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eg_members/1 or /eg_members/1.json
  def destroy
    @eg_member.destroy

    respond_to do |format|
      format.html { redirect_to eg_members_url, notice: "Eg member was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_eg_member
      @eg_member = EgMember.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def eg_member_params
      params.require(:eg_member).permit(:full_name, :email, :eg_type, :active)
    end
end
