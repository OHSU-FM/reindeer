class CreateTempCompetencyTable < ActiveRecord::Migration[7.2]
  def change
    execute 'create table temp_competencies as (select * from competencies) with no data;'
  end
end
