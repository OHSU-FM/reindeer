class GetRidOfOldCoaching < ActiveRecord::Migration
  def change
    drop_table :assignment_group_templates, force: :cascade
    drop_table :assignment_groups, force: :cascade
    drop_table :survey_assignments, force: :cascade
    drop_table :user_assignments, force: :cascade
    drop_table :user_responses, force: :cascade
  end
end
