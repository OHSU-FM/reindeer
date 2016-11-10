class AddSubmitdateToUserResponse < ActiveRecord::Migration
  def change
    add_column :user_responses, :submitdate, :text
  end
end
