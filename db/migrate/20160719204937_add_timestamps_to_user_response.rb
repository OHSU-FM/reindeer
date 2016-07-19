class AddTimestampsToUserResponse < ActiveRecord::Migration
  def change
    add_column :user_responses, :created_at, :datetime
    add_column :user_responses, :updated_at, :datetime
  end
end
