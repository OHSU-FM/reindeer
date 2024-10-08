class CreateNewCompetencies < ActiveRecord::Migration[7.2]
  def change
    create_table :new_competencies do |t|
      t.integer :user_id
      t.integer :permission_group_id
      t.string :student_uid
      t.string :email
      t.string :medhub_id
      t.string :course_name
      t.string :course_id
      t.date :start_date
      t.date :end_date
      t.date :submit_date
      t.string :evaluator
      t.string :final_grade
      t.string :environment
      t.integer :ics1, limit: 2
      t.integer :ics2, limit: 2
      t.integer :ics3, limit: 2
      t.integer :ics4, limit: 2
      t.integer :ics5, limit: 2
      t.integer :mk1, limit: 2
      t.integer :mk2, limit: 2
      t.integer :mk3, limit: 2
      t.integer :pbli1, limit: 2
      t.integer :pbli2, limit: 2
      t.integer :pbli3, limit: 2
      t.integer :pcp1, limit: 2
      t.integer :pcp2, limit: 2
      t.integer :pcp3, limit: 2
      t.integer :pppd1, limit: 2
      t.integer :pppd2, limit: 2
      t.integer :sbpic1, limit: 2
      t.text :prof_concerns
      t.text :comm_prof_concerns
      t.text :overall_summ_comm_perf
      t.text :add_comm_on_perform
      t.text :mspe
      t.text :clinic_exp_comment
      t.text :feedback
      t.timestamps

    end
    add_index :new_competencies, [:user_id, :id], :unique => true
    add_index :new_competencies, [:permission_group_id,:user_id], :unique => true
  end
end
