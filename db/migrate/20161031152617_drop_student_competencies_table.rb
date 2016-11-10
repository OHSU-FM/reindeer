class DropStudentCompetenciesTable < ActiveRecord::Migration
  def up
      drop_table :student_competencies
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
