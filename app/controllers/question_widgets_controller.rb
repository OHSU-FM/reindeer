class QuestionWidgetsController < ApplicationController
  def create
    @question_widget = QuestionWidget.new(question_widget_params)
    authorize! :create, @question_widget
    dash = Dashboard.where(user_id: current_user.id).first_or_create
    dash_widget = @question_widget.build_dash_widget
    dash_widget.dashboard_id = dash.id
    dash_widget.widget_title = ActionController::Base.helpers.strip_tags(@question_widget.lime_question.question)

    respond_to do |format|
      if @question_widget.save
        format.html { redirect to root_path, notice: 'Added to dashboard' }
        format.json { render json: { message: 'Added to dashboard',
                                     dash_widget_id: dash_widget.id },
                      status: :created}
      else
        format.html { redirect to root_path, notice: 'Error adding to dashboard' }
        format.json { render json: { message: 'Error adding to dashboard' },
                      status: :unprocessable_entity }
      end
    end
  end

  private

  def question_widget_params
    params.require(:question_widget)
      .permit(:view_type, :user_id, :role_aggregate_id, :agg, :pk, :graph_type,
    :lime_question_qid)
  end
end
