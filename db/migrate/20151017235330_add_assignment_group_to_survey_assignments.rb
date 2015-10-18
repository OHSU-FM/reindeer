class AddAssignmentGroupToSurveyAssignments < ActiveRecord::Migration
  def change
    add_reference :survey_assignments, :assignment_group, index: true, foreign_key: true
  end
end
