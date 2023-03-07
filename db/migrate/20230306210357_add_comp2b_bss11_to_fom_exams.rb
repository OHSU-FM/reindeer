class AddComp2bBss11ToFomExams < ActiveRecord::Migration[6.1]
  def change
    add_column :fom_exams, :comp2b_bss11, :decimal
    add_column :fom_exams, :comp2b_bss12, :decimal
  end
end
