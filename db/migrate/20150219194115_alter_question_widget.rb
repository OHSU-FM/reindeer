class AlterQuestionWidget < ActiveRecord::Migration

  def up
    # Add title to widgets
    add_column :dashboard_widgets, :widget_title, :string

    remove_column :question_widgets, :role_aggregate_email
    remove_column :question_widgets, :role_aggregate_agg

    add_column :question_widgets, :agg, :string
    add_column :question_widgets, :pk, :string
    add_column :question_widgets, :user_id, :integer
    add_column :question_widgets, :graph_type, :string
  end

  def down

    remove_column :dashboard_widgets, :widget_title

    add_column :question_widgets, :role_aggregate_email, :string
    add_column :question_widgets, :role_aggregate_agg, :string
    remove_column :question_widgets, :agg
    remove_column :question_widgets, :pk
    remove_column :question_widgets, :user_id
    remove_column :question_widgets, :graph_type
  end

end
