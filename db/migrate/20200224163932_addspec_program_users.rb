class AddspecProgramUsers < ActiveRecord::Migration[5.2]
  def change
      add_column :users, :spec_program, :string
      add_column :users, :sid, :string
  end
end
