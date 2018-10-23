class LsReportsController < ApplicationController
  layout 'full_width_margins'
  respond_to :json, :html

  ##
  # show all roles
  def index
    authorize! :list, LimeSurvey

    # List role_aggregates in order of last updated date
    surveys = current_user.lime_surveys_by_most_recent

    # Group surveys by group title
    @survey_groups = LimeExt::LimeSurveyGroup.classify(surveys,
                                                       params)

    # collect role aggregates
    @role_aggregates = @survey_groups.role_aggregates

    # Sort groups alphabetically
    @survey_groups.sort_by{|group| group.title }

    @cohorts = current_user.cohorts
    @recent = surveys.first(5)
  end
end
