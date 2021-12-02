class LsReportsController < ApplicationController
  include LsReportsHelper
  include ArtifactsHelper
  layout 'full_width_margins'
  respond_to :json, :html

  ##
  # show all roles
  def index
    authorize! :list, LimeSurvey

    # List role_aggregates in order of last updated date
    surveys ||= current_user.lime_surveys_by_most_recent

    # Group surveys by group title
    @survey_groups ||= LimeExt::LimeSurveyGroup.classify(surveys, params)
    # collect role aggregates
    @role_aggregates ||= @survey_groups.role_aggregates

    # Sort groups alphabetically
    @survey_groups.sort_by{|group| group.title }

    @cohorts = current_user.cohorts
    #@recent = surveys.first(5)
    if !@survey_groups.blank?
      cohort = @survey_groups.first.title.split(":").second
    end

    @csl_feedbacks_title ||= CslFeedback.where("csl_title like ?", "%#{cohort}%").pluck(:csl_title).uniq

  end
end
