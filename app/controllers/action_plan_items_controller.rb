class ActionPlanItemsController < ApplicationController
  before_action :set_action_plan_item, only: [:create, :show, :edit, :update, :destroy]
  respond_to :html, :js

  # GET /action_plan_items
  def index
    @action_plan_items = ActionPlanItem.all
  end

  # GET /action_plan_items/1
  def show
  end

  # GET /action_plan_items/new
  def new
    @action_plan_item = ActionPlanItem.new
    binding.pry
    if @action_plan_item.save
      redirect_to @action_plan_item, notice: 'Action plan item was successfully created.'
    else
      render :new
    end   
  end

  # GET /action_plan_items/1/edit
  def edit
  end

  # POST /action_plan_items
  def create

    @action_plan_item = ActionPlanItem.new(action_plan_item_params)
    @action_plan_item

    if @action_plan_item.save
      redirect_to @action_plan_item, notice: 'Action plan item was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /action_plan_items/1
  def update
    if @action_plan_item.update(action_plan_item_params)
      redirect_to @action_plan_item, notice: 'Action plan item was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /action_plan_items/1
  def destroy
    puts "In Destroy"
    binding.pry
    @action_plan_item.destroy
    redirect_to action_plan_items_url, notice: 'Action plan item was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_action_plan_item
      @action_plan_item = ActionPlanItem.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def action_plan_item_params
      params.require(:action_plan_item).permit(:description, :goal_id)

    end
end
