class AddForeignKeyConstraintsToLimeSurveys < ActiveRecord::Migration[4.2]
  def change
    execute <<-SQL
        ALTER TABLE role_aggregates
        ADD CONSTRAINT lime_survey_sid_fk FOREIGN KEY (lime_survey_sid)
            REFERENCES #{LimeSurvey.table_name} (sid) ON DELETE CASCADE
    SQL
  end
end
