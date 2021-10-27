class AddComp5aHss4ToMed22FomExams < ActiveRecord::Migration[6.1]
  def change
    add_column :med22_fom_exams, :comp5a_hss4, :decimal
  end
end
