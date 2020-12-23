class AddAdviceCategoryToMeetings < ActiveRecord::Migration[5.2]
  def change
        add_column :meetings, :advice_category, :string
  end
end
