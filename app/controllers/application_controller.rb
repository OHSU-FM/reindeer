class ApplicationController < ActionController::Base
    protect_from_forgery
    before_filter :authenticate_user!
    helper_method :auto_path

    rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
        flash[:alert] = 'Unable to reach authentication server'
        respond_to do |format|
            format.html { render 'errors/internal_server_error', :status=>500 }
            format.js { render json: {message: 'Internal Server Error'}, status: 500}
        end
    end

    rescue_from ActiveRecord::RecordNotFound, ActionController::BadRequest,
                ActionController::RoutingError,
                ActionController::UnknownController,
                ActionController::MethodNotAllowed do |exception|
        respond_to do |format|
            format.html { render 'errors/file_not_found', :status=>404 }
            format.js { render json: {message: 'File not found'}, status: 404}
        end
    end

    # https://github.com/ryanb/cancan/#3-handle-unauthorized-access
    rescue_from CanCan::AccessDenied do |exception|
        unless params[:controller] == 'dashboard' && params[:action] == 'index'
            flash[:alert] = exception.message
        end
        respond_to do |format|
            format.html { render 'errors/not_authorized', :status=>403, :layout=>'full_width_margins' }
            format.js { render json: {message: 'Not Authorized'}, status: 403 }
        end
    end


    private

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
                format.html {redirect_to opts[:to] }
                format.json { render :json=>opts[:json], :status=>opts[:status] }
            end
        rescue => e
            redirect_to auto_path
        end
    end

    def auto_path
        # Det
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
        auto_path
    end

    def simple_respond opts=nil
      opts ||= params
      respond_to do |format|
          layout = !(opts[:layout].to_s == 'false')
          format.html { render layout: layout } # show
      end
    end


end
