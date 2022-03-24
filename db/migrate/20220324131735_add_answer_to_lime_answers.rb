class AddAnswerToLimeAnswers < ActiveRecord::Migration[6.1]
  def change
    add_column :lime_answers, :answer, :text
  end
end
