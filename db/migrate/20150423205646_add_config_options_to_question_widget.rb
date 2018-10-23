class AddConfigOptionsToQuestionWidget < ActiveRecord::Migration[4.2]
  def up
      ActiveRecord::Base.transaction do
          add_column :question_widgets, :view_type, :string 
          QuestionWidget.update_all(:view_type=>'graph') 
      end
  end

  def down
    remove_column :question_widgets, :view_type
  end
end
