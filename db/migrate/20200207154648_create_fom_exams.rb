class CreateFomExams < ActiveRecord::Migration[5.2]
  def change
    create_table :fom_exams do |t|
       t.string :course_code
       t.datetime :submit_date
       t.decimal :comp1_wk1
       t.decimal :comp1_wk2
       t.decimal :comp1_wk3
       t.decimal :comp1_wk4
       t.decimal :comp1_wk5
       t.decimal :comp1_wk6
       t.decimal :comp1_wk7
       t.decimal :comp1_wk8
       t.decimal :comp1_wk9
       t.decimal :comp1_wk10
 	     t.decimal :comp1_wk11
 	     t.decimal :comp1_wk12
       t.decimal :comp1_dropped_score
       t.string  :comp1_dropped_quiz
 	     t.decimal :comp2a_hss1
 	     t.decimal :comp2a_hss2
 	     t.decimal :comp2a_hss3
 	     t.decimal :comp2a_hss4
 	     t.decimal :comp2a_hss5
 	     t.decimal :comp2a_hss6
 	  t.decimal :comp2a_hssavg
 	  t.decimal :comp2b_bss1
 	  t.decimal :comp2b_bss2
 	  t.decimal :comp2b_bss3
 	  t.decimal :comp2b_bss4
 	  t.decimal :comp2b_bss5
 	  t.decimal :comp2b_bss6
 	  t.decimal :comp2b_bss7
 	  t.decimal :comp2b_bss8
 	  t.decimal :comp2b_bss9
 	  t.decimal :comp2b_bssavg
 	  t.decimal :comp3_final1
 	  t.decimal :comp3_final2
 	  t.decimal :comp3_final3
 	  t.decimal :comp4_nbme
 	  t.decimal :comp5a_hss1
 	  t.decimal :comp5a_hss2
 	  t.decimal :comp5a_hss3
 	  t.decimal :comp5a_hssavg
 	  t.decimal :comp5b_bss1
 	  t.decimal :comp5b_bss2
 	  t.decimal :comp5b_bss3
 	  t.decimal :comp5b_bss4
 	  t.decimal :comp5b_bss5
 	  t.decimal :comp5b_bssavg
 	  t.decimal :summary_comp1
 	  t.decimal :summary_comp2a
 	  t.decimal :summary_comp2b
 	  t.decimal :summary_comp3
 	  t.decimal :summary_comp4
 	  t.decimal :summary_comp5a
 	  t.decimal :summary_comp5b
    t.references :user, foreign_key: true
    t.timestamps
     end
    add_index :fom_exams, [:user_id, :course_code], :unique => true, :name => 'by_user_course_code'
  end
end
