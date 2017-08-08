class GetRidOfOldCoaching < ActiveRecord::Migration
  def change
    drop_table :assignment_group_templates, force: :cascade
    drop_table :assignment_groups, force: :cascade
    drop_table :survey_assignments, force: :cascade
    drop_table :user_assignments, force: :cascade
    drop_table :user_responses, force: :cascade
    drop_table :meta_attribute_entities, force: :cascade
    drop_table :meta_attribute_groups, force: :cascade
    drop_table :meta_attribute_entity_groups, force: :cascade
    drop_table :meta_attribute_questions, force: :cascade
    drop_table :meta_attribute_statistics, force: :cascade
    drop_table :meta_attribute_values, force: :cascade
  end
end
