class AddAdvisorIdToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :advisor_id, :integer
    add_index :events, [:advisor_id, :id], unique: true
  end
end
