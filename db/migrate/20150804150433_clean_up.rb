class CleanUp < ActiveRecord::Migration
  def change
    remove_column :survey_assignments, :shared_response_qids
  end
end
