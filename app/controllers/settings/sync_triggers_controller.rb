class Settings::SyncTriggersController < ApplicationController
  layout 'full_width'
  before_filter :authorize_access

  def index
    @triggers = LimeExt::SyncTrigger.all
    simple_respond
  end

  def show
    @trigger = LimeExt::SyncTrigger.find(params[:id].to_s)
    simple_respond layout: false
  end

  def new
    #binding.pry
    @trigger = LimeExt::SyncTrigger.new(build_trigger_params)
    @ready_post = @trigger.valid?
    @method = @ready_post ? :post : :get
    @action = @ready_post ? :create : :new
    simple_respond layout: false
  end

  def destroy
    @trigger = LimeExt::SyncTrigger.find(show_trigger_params)
    @trigger.destroy
    flash[:notice] = 'Trigger Deleted'
    redirect_to action: :index
  end

  def create
    @trigger = LimeExt::SyncTrigger.new(create_trigger_params)
    @trigger.save!
    simple_redirect to: settings_sync_triggers_path
  end

  private

  def authorize_access
    authorize! :crud, LimeExt::SyncTrigger
  end

  def show_trigger_params
    params.require(:id)
  end

  def create_trigger_params
    result = params.require(:lime_ext_sync_trigger).permit(:sid_src, :sid_dest, :map_src, :map_dest, cols_vals: [], cols_keys: [])
    return capture_cols_hash result
  end

  def build_trigger_params
    if params.include? :lime_ext_sync_trigger
      create_trigger_params
    end
  end

  def capture_cols_hash result
    if result.include?(:cols_vals) || result.include?(:cols_keys)
      # Remove keys and vals
      keys = result.delete(:cols_keys) || []
      vals = result.delete(:cols_vals) || keys.count.times.map{nil}
      # Combine keys and vals back in to hash
      result[:cols] = Hash[keys.zip(vals)]
      result[:cols].delete nil
      result[:cols].delete ''
    end
    result
  end

end

