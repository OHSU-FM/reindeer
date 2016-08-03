class AddOwnerStatusToUserResponse < ActiveRecord::Migration
  def change
    add_column :user_responses, :owner_status, :string
  end
end
