class AddComp2bBss10ToFomExams < ActiveRecord::Migration[6.1]
  def change
    add_column :fom_exams, :comp2b_bss10, :decimal
  end
end
