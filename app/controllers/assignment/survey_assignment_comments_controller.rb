class Assignment::SurveyAssignmentCommentsController < ApplicationController

  def show
    survey = Assignment::AssignmentSurvey.includes(:comments).find(params[:survey_assignment_id])
    @comments = survey.comments
    render template: 'assignment/assignment_comments/index'
  end

end
