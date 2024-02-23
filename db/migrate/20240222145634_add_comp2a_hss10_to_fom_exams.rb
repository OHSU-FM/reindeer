class AddComp2aHss10ToFomExams < ActiveRecord::Migration[7.1]
  def change
    add_column :fom_exams, :comp2a_hss10, :decimal
    add_column :fom_exams, :comp2a_hss11, :decimal
    add_column :fom_exams, :comp2a_hss12, :decimal
    add_column :fom_exams, :comp2a_hss13, :decimal
    add_column :fom_exams, :comp2a_hss14, :decimal
    add_column :fom_exams, :comp2a_hss15, :decimal
    add_column :fom_exams, :comp2a_hss16, :decimal
    add_column :fom_exams, :comp2a_hss17, :decimal
    add_column :fom_exams, :comp2a_hss18, :decimal
    add_column :fom_exams, :comp2a_hss19, :decimal
    add_column :fom_exams, :comp2a_hss20, :decimal
    add_column :fom_exams, :comp2a_hss21, :decimal               
  end
end
