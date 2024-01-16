class AddComp2aHss8ToFomExams < ActiveRecord::Migration[7.1]
  def change
    add_column :fom_exams, :comp2a_hss8, :decimal
    add_column :fom_exams, :comp2a_hss9, :decimal
  end
end
