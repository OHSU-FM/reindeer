class Assignment::AssignmentGroupTemplatesController < ApplicationController
  respond_to :html, :json
  authorize_resource

  def index
    @assignment_group_templates = Assignment::AssignmentGroupTemplate.all
    respond_with @assignment_group_templates
  end

  def show
    @assignment_group_template = Assignment::AssignmentGroupTemplate.find(params[:id])
    respond_with @assignment_group_template
  end

  def new
    @assignment_group_template = Assignment::AssignmentGroupTemplate.new
    respond_with @assignment_group_template
  end

  def create
    @assignment_group_template = Assignment::AssignmentGroupTemplate.create create_params
    respond_with @assignment_group_template
  end

  def edit
    @assignment_group_template = Assignment::AssignmentGroupTemplate.find(params[:id])
    respond_with @assignment_group_template
  end

  def update
    @assignment_group_template = Assignment::AssignmentGroupTemplate.find(params[:id])
    @assignment_group_template.update(update_params)
    respond_with @assignment_group_template
  end

  def destroy
    @assignment_group_template = Assignment::AssignmentGroupTemplate.find(params[:id])
    @assignment_group_template.destroy!
    respond_with @assignment_group_template
  end

  protected

  def create_params
    params.require(:assignment_assignment_group_template).permit!
  end

  def update_params
    params.require(:assignment_assignment_group_template).permit!
  end

  def index_location
    assignment_assignment_group_templates_path
  end
end
