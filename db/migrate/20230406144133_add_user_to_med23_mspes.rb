class AddUserToMed23Mspes < ActiveRecord::Migration[7.0]
  def change
    add_reference :med23_mspes, :user, foreign_key: true
  end
end
