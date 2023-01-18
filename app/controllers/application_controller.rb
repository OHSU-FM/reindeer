class ApplicationController < ActionController::Base
  before_action :set_cache_buster
  protect_from_forgery with: :exception

 helper :all

  before_action :authenticate_user!
  before_action :dynamic_destroy, only: :update
  helper_method :auto_path
  before_action :store_current_location, unless: :devise_controller?

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    flash[:alert] = 'Unable to reach authentication server'
    respond_to do |format|
      format.html { render 'errors/internal_server_error', status: 500 }
      format.js { render json: { message: 'Internal Server Error' }, status: 500 }
    end
  end

  rescue_from ActiveRecord::RecordNotFound, ActionController::BadRequest,
    ActionController::RoutingError,
    ActionController::MethodNotAllowed do |exception|
    respond_to do |format|
      format.html { render 'errors/file_not_found', status: 404 }
      format.js { render json: { message: 'File not found' }, status: 404 }
    end
  end

  # https://github.com/ryanb/cancan/#3-handle-unauthorized-access
  rescue_from CanCan::AccessDenied do |exception|
    unless params[:controller] == 'dashboard' && params[:action] == 'index'
      flash[:alert] = exception.message
    end
    respond_to do |format|
      format.html { render 'errors/not_authorized', status: 403, layout: 'full_width_margins' }
      format.js { render json: { message: 'Not Authorized' }, status: 403 }
    end
  end

  def route_not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  private

  def set_cache_buster
    headers["Cache-Control"] = "no-cache, no-store, must-revalidate" # HTTP 1.1.
    headers["Pragma"] = "no-cache" # HTTP 1.0.
    headers["Expires"] = "0" # Proxies.
  end

  def store_current_location
    store_location_for(:user, request.url)
  end

  # Default Devise redirect does not work with RAILS_RELATIVE_URL_ROOT
  # Manually setting redirect path here
  # http://blog.patrickespake.com/devise-redirect-to-a-specific-path-after-destroy-the-session/
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  # simple redirect on bad request
  def simple_redirect opts={}
    opts[:to] ||= :back
    opts[:json] ||= flash
    opts[:status] ||= :ok

    begin
      respond_to do |format|
        format.html { redirect_to opts[:to] }
        format.json { render json: opts[:json], status: opts[:status] }
      end
    rescue => e
      redirect_to auto_path
    end
  end

  def auto_path
    respond_to do |format|
      return main_app.dashboards_path if can?(:crud, Dashboard)
      return main_app.reports_path if can?(:read, :reports)
      return main_app.stats_path if can?(:read, :stats)
      return main_app.charts_path if can?(:crud, Chart)
      return main_app.user_path(current_user) if current_user.present?
      return main_app.page_path('no_permissions')
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(:user) || auto_path
  end

  def simple_respond opts=nil
    opts ||= params
    respond_to do |format|
      layout = !(opts[:layout].to_s == 'false')
      format.html { render layout: layout } # show
    end
  end

  # Process updates as destroy if _destroy is specified
  def dynamic_destroy
    if params[:_destroy] == '1'
      destroy
      return
    end
  end
end
