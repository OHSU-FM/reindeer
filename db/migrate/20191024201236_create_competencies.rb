class CreateCompetencies < ActiveRecord::Migration[5.2]
  def change
    create_table :competencies do |t|
      t.references :user, index: true, foreign_key: true
      t.references :permission_group, index:true, foreign_key: true
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
      t.integer :ics1, :limit => 2
      t.integer :ics2, :limit => 2
      t.integer :ics3, :limit => 2
      t.integer :ics4, :limit => 2
      t.integer :ics5, :limit => 2
      t.integer :ics6, :limit => 2
      t.integer :ics7, :limit => 2
      t.integer :ics8, :limit => 2
      t.integer :mk1, :limit => 2
      t.integer :mk2, :limit => 2
      t.integer :mk3, :limit => 2
      t.integer :mk4, :limit => 2
      t.integer :mk5, :limit => 2
      t.integer :pbli1, :limit => 2
      t.integer :pbli2, :limit => 2
      t.integer :pbli3, :limit => 2
      t.integer :pbli4, :limit => 2
      t.integer :pbli5, :limit => 2
      t.integer :pbli6, :limit => 2
      t.integer :pbli7, :limit => 2
      t.integer :pbli8, :limit => 2
      t.integer :pcp1, :limit => 2
      t.integer :pcp2, :limit => 2
      t.integer :pcp3, :limit => 2
      t.integer :pcp4, :limit => 2
      t.integer :pcp5, :limit => 2
      t.integer :pcp6, :limit => 2
      t.integer :pppd1, :limit => 2
      t.integer :pppd2, :limit => 2
      t.integer :pppd3, :limit => 2
      t.integer :pppd4, :limit => 2
      t.integer :pppd5, :limit => 2
      t.integer :pppd6, :limit => 2
      t.integer :pppd7, :limit => 2
      t.integer :pppd8, :limit => 2
      t.integer :pppd9, :limit => 2
      t.integer :pppd10, :limit => 2
      t.integer :pppd11, :limit => 2
      t.integer :sbpic1, :limit => 2
      t.integer :sbpic2, :limit => 2
      t.integer :sbpic3, :limit => 2
      t.integer :sbpic4, :limit => 2
      t.integer :sbpic5, :limit => 2
      t.text :prof_concerns
      t.text :comm_prof_concerns
      t.text :overall_summ_comm_perf
      t.text :add_comm_on_perform
      t.text :mspe
      t.text :clinic_exp_comment
      t.text :feedback
      t.timestamps
    end
  end
end
