class DashboardController < ApplicationController
  include LsReportsHelper
  include DashboardHelper
  include EpaMastersHelper
  layout 'full_width'

  def index
    unless can? :crud, Dashboard
      redirect_to auto_path
      return
    end
    get_artifacts
    #@surveys = current_user.lime_surveys_by_most_recent(5)
    @dash = Dashboard.where(user_id: current_user.id).first_or_initialize  #includes(:dashboard_widgets)
    if current_user.coaching_type == 'student'
      @meetings = Coaching::Meeting.where("user_id=? and event_id is not NULL", current_user.id)
      student = User.where(id: current_user.id)
      @wba_epa_data = hf_process_student(student, 'WBA')
      @wba_clinical_assessor_data = hf_process_student(student, 'ClinicalAssessor')
    else
      if Advisor.exists?(email: current_user.email)
        @yes_advisor = true
      else
        @yes_advisor = false
      end
      @meetings = []
    end

    authorize! :read, @dash
    #do_gon   # disable dashboard_widgets
    respond_to do |format|
      layout = !(params[:layout] == 'false')
      format.html{ render layout: layout }
      format.json{ render json: { dash: @dash } }
    end
  end

  def show
    @dash = Dashboard.find(params[:id].to_i)
    # @dash.dashboard_widgets.build if @dash.dashboard_widgets.nil?
    # authorize! :read, @dash
    # do_gon

    respond_to do |format|
      layout = !(params[:layout] == 'false')
      format.html{ render layout: layout }
      format.json{ render json: { dash: @dash } }
    end
  end

  def create
    @dash = Dashboard.where(user_id: current_user.id).first_or_initialize
    @dash.assign_attributes(dashboard_params)
    authorize! :create, @dash


    respond_to do |format|
      if @dash.save!
        format.html{ redirect_to dashboard_path(@dash) }
        format.json{ render json: { dash: @dash }, status: :ok }
      else
        format.html{ render action: "new" }
        format.json{ render json: { dash: @dash },
                     status: :unprocessable_entity }
      end
    end
  end

  def update

    #@dash = Dashboard.find(params[:id].to_i)
    #authorize! :update,:create, @dash
    # params[:theme] comes from ajax call
    @dash = Dashboard.where(user_id: current_user.id).first_or_create.update(theme: params[:theme])

    respond_to do |format|
      if @dash #.update(dashboard_params)
        format.html{ render action: :show}
        format.json{ render json: { dash: @dash }, status: :ok }
      else
        format.html{ render action: :index }
        format.json{ render json: { dash: @dash },
                     status: :unprocessable_entity }
      end
    end
  end

  private

  def get_artifacts
    @artifacts = User.find(current_user.id).artifacts
    @no_of_docs = 0
    @artifacts.each do |artifact|
      if artifact.documents.attached?
           @no_of_docs += artifact.documents.count.to_s.to_i
      end
    end

  end

  def do_gon
    gon.dashboard_widgets = @dash.dashboard_widgets
  end

  def dashboard_params
    params
      .require(:dashboard)
      .permit(:theme,
              dashboard_widgets_attributes: [:widget_title, :position, :sizex,
                                             :sizey, :id, :_destroy ]
             )
  end
end
