class AddIndexToEpas < ActiveRecord::Migration[5.2]
  def change
    add_column :epas, :response_id, :string
    add_index :epas, :response_id
  end
end
