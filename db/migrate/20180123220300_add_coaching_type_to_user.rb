class AddCoachingTypeToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :coaching_type, :string
  end
end
