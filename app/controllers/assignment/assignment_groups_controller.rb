class Assignment::AssignmentGroupsController < Assignment::AssignmentBaseController
  layout "full_width_height_margins"
  respond_to :html
  authorize_resource
  before_action :load_resource, only: [:show, :edit, :update, :destroy]

  def index
    @assignment_groups = current_user.active_assignment_groups
    if @assignment_groups.count > 0
      redirect_to assignment_assignment_group_path(@assignment_groups.first)
    end
  end

  def show
    @assignment_group = Assignment::AssignmentGroup.find(params[:assignment_group_id])
    if current_ability.can? :comment_on, @assignment_group
      @new_ag_comment = Comment.new(commentable: @assignment_group,
                                    user: current_user)
    end

    @assignment_groups = if current_user.active_assignment_groups.count >= 1
                           current_user.active_assignment_groups
                         else
                           nil
                         end

    unless params[:user_id]
      params[:user_id] = if @assignment_group.user_ids.include? current_user.id
        current_user.id
      else
        @assignment_group.user_ids.sort.find{|id| !id.blank?}.to_s
      end
    end
    @user = User.find(params[:user_id])

    @service = Assignment::UserAssignmentsIndexService.new @assignment_group, params
    @thread = @assignment_group.cohort.comment_thread_for(@user.id)
    @new_thread_comment = Comment.new(commentable: @thread, user: current_user)
  end

  def new
    @assignment_group = Assignment::AssignmentGroup.new
    simple_respond
  end

  def create
    @assignment_group = Assignment::AssignmentGroup.create(create_params)
    flash[:success] = "#{Settings.assignments_route_name.singularize.titleize} successfully created!"
    redirect_to assignment_assignment_group_path(@assignment_group)
  end

  def edit
  end

  def update
    @assignment_group.update_attributes(update_params)
    @assignment_group.save!
    flash[:success] = "#{Settings.assignments_route_name.singularize.titleize} successfully updated!"
    redirect_to assignment_assignment_group_path(@assignment_group)
  end

  def destroy
    @assignment_group.destroy
    flash[:success] = "#{Settings.assignments_route_name.singularize.titleize} successfully deleted!"
    redirect_to assignment_assignment_groups_path
  end

  protected

  def load_resource
    @assignment_group = Assignment::AssignmentGroup.find(params[:assignment_group_id])
  end

  def create_params
    update_params
  end

  def update_params
    params.require(:assignment_assignment_group).
      permit(:assignment_group_template_id, :title, :desc_md, :cohort_id)
  end

end
