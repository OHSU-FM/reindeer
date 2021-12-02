class AddOtherRoleToEpas < ActiveRecord::Migration[6.1]
  def change
    add_column :epas, :other_role, :string
  end
end
