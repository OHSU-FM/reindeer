class LsReportsController < ApplicationController
    include LsReportsHelper
    layout 'full_width_margins'
    respond_to :json, :html

    ##
    # show all roles
    def index
        authorize! :list, LimeSurvey

        # List role_aggregates in order of last updated date
        surveys = current_user.lime_surveys.sort_by{|lime_survey|
          lime_survey.last_updated.to_s.to_date
        }
          
        # Group surveys by group title
        @survey_groups = LimeExt::LimeSurveyGroup.classify(surveys, 
          filter: params[:filter])
        
        # collect role aggregates
        @role_aggregates = @survey_groups.role_aggregates

        # Sort groups alphabetically
        @survey_groups.sort_by{|group| group.title }
    end

end
