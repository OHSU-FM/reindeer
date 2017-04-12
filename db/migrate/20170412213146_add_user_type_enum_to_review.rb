class AddUserTypeEnumToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :user_type, :integer, default: 0
  end
end
