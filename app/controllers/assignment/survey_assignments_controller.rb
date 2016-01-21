module Assignment
  class SurveyAssignmentsController < Assignment::AssignmentBaseController

    respond_to :html, :json
    authorize_resource

    def index
      @survey_assignments = Assignment::SurveyAssignment.all
      respond_with @survey_assignments
    end

    def show
      @survey_assignment = Assignment::SurveyAssignment.find(params[:id])
      respond_with @survey_assignment
    end

    def new
      @survey_assignment = Assignment::SurveyAssignment.new
      respond_with @survey_assignment
    end

    def create
      @survey_assignment = Assignment::SurveyAssignment.create create_params
      respond_with @survey_assignment
    end

    def edit
      @survey_assignment = Assignment::SurveyAssignment.find(params[:id])
      respond_with @survey_assignment
    end

    def update
      @survey_assignment = Assignment::SurveyAssignment.find(params[:id])
      @survey_assignment.update(update_params)
      respond_with @survey_assignment
    end

    def destroy
      @survey_assignment = Assignment::SurveyAssignment.find(params[:id])
      @survey_assignment.destroy!
      respond_with @survey_assignment
    end

    protected

    def create_params
      params.require(:assignment_assignment_group_template).permit!
    end

    def update_params
      params.require(:assignment_assignment_group_template).permit!
    end

    def index_location
      assignment_survey_assignments_path
    end

  end
end
