class CreateQuestionWidgets < ActiveRecord::Migration
  def change
    create_table :question_widgets do |t|
        t.integer :role_aggregate_id
        t.string :role_aggregate_email
        t.string :role_aggregate_agg
        t.integer :lime_question_qid
        t.timestamps
    end
  end
end
