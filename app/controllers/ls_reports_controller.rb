class LsReportsController < ApplicationController
    include LsReportsHelper
    layout 'full_width_margins'
    respond_to :json, :html

    ##
    # show all roles
    def index
        authorize! :list, LimeSurvey
        @role_aggregates = current_user.role_aggregates
    end

    def back_to_index
        respond_to do |format|
            format.html do
                flash[:notice] = ''
                redirect_to ls_reports_path
            end
        end
    end
end
