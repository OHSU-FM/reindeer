class AddNewCompetencyFlagToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :new_competency, :boolean, default: false
    add_column :users, :former_name, :string
    add_column :users, :career_interest, :string, array: true, default: []
  end
end
