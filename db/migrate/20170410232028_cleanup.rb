class Cleanup < ActiveRecord::Migration
  def change
    drop_table :user_responses, force: true
    drop_table :user_assignments, force: true
    drop_table :survey_assignments, force: true
    drop_table :assignment_groups, force: true
    drop_table :assignment_group_templates, force: true
    drop_table :cohorts, force: true
    drop_table :comments, force: true
    drop_table :compentencies, force: true
    drop_table :meta_attribute_entity_groups, force: true
    drop_table :meta_attribute_groups, force: true
  end
end
