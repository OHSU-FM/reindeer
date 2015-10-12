class AddSurveyAssignmentToAssignmentGroup < ActiveRecord::Migration
  def change
    add_reference :assignment_groups, :survey_assignment, index: true, foreign_key: true
  end
end
