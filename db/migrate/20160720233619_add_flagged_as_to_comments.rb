class AddFlaggedAsToComments < ActiveRecord::Migration
  def change
    add_column :comments, :flagged_as, :string
  end
end
