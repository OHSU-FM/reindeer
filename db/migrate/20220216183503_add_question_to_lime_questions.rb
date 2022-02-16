class AddQuestionToLimeQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :lime_questions, :question, :text
  end
end
