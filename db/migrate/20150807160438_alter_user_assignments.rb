class AlterUserAssignments < ActiveRecord::Migration
  def change
    rename_column :survey_assignments, :show_groups, :as_inline
    add_foreign_key :user_assignments, :survey_assignments, on_delete: :cascade
    add_foreign_key :survey_assignments, :lime_surveys, on_delete: :cascade, 
      primary_key: :sid, column: :lime_survey_sid
  end
end
