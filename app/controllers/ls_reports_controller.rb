class LsReportsController < ApplicationController
    include LsReportsHelper
    layout 'full_width_margins'
    respond_to :json, :html

    ##
    # show all roles
    def index
        authorize! :list, LimeSurvey
        # List role_aggregates in order of date
        @role_aggregates = current_user.role_aggregates.sort_by{|ra|ra.lime_survey.last_updated.to_s.to_date}
        # Group surveys by group title
        @survey_groups = PermissionGroups::RoleAggregateGroup.classify(@role_aggregates)
        # Filter groups if filter present
        if params[:filter].present?
          @survey_groups.select!{|group|group.title == params[:filter]}
          @role_aggregates = @survey_groups.map{|group|group.role_aggregates}.flatten
        end
        # Sort groups alphabetically
        @survey_groups.sort_by{|group| group.title }
    end

    protected

    def back_to_index
        respond_to do |format|
            format.html do
                flash[:notice] = ''
                redirect_to ls_reports_path
            end
        end
    end
end
