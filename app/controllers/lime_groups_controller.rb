class LimeGroupsController < ApplicationController
    layout 'full_width'

  def index
      @role_aggregates = RoleAggregate.includes(:lime_group).where(:user_id=>current_user.id)
      @lime_groups = @role_aggregates.map{|ra|ra.lime_group}
  end


 def show
      @lime_group = LimeGroup.joins(:role_aggregates).
         where(sid:params[:id].to_i).
          includes(:t_questions).first


      unless @lime_group
          flash[:error] = "lime_group  not found"
          redirect_to :action => :index
      end
  end

  def show_details
	puts params
  end
end
