class AddShortNameToMetaAttributeQuestions < ActiveRecord::Migration
  def change
    add_column :meta_attribute_questions, :short_name, :text
  end
end
