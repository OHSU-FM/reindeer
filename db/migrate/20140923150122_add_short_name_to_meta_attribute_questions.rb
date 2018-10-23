class AddShortNameToMetaAttributeQuestions < ActiveRecord::Migration[4.2]
  def change
    add_column :meta_attribute_questions, :short_name, :text
  end
end
