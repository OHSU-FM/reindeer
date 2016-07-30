class AddCompletionTargetAndStatusExplanationToUserResponse < ActiveRecord::Migration
  def change
    add_column :user_responses, :completion_target, :string
    add_column :user_responses, :status_explanation, :string
  end
end
