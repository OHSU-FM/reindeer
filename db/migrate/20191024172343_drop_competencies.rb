class DropCompetencies < ActiveRecord::Migration[5.2]
  def change
	drop_table :competencies
  end
end
