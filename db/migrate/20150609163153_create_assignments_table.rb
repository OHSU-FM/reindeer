class CreateAssignmentsTable < ActiveRecord::Migration
  def change

    create_table :survey_assignments do |t|
        t.boolean :show_groups, :default=>false
        t.string :title
        t.integer :lime_survey_sid, :null=>false
        t.text :shared_response_qids
        t.timestamps
    end
    add_index :survey_assignments, :lime_survey_sid

    create_table :user_assignments do |t|
        t.references :user, :null=>false
        t.references :survey_assignment, :null=>false
        t.integer :lime_token_tid
        t.datetime :started_at
        t.timestamps
    end
    add_index :user_assignments, [:user_id, :survey_assignment_id], 
        :unique=>true, :name=>:uniq_sid_by_user
  end
end
