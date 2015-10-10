class AddForeignKeyConstraintsToLimeSurveys < ActiveRecord::Migration
  def change
    execute <<-SQL
        ALTER TABLE role_aggregates
        ADD CONSTRAINT lime_survey_sid_fk FOREIGN KEY (lime_survey_sid)
            REFERENCES #{LimeSurvey.table_name} (sid) ON DELETE CASCADE
    SQL
    execute <<-SQL
        ALTER TABLE user_lime_permissions
        ADD CONSTRAINT role_aggregate_id_fk FOREIGN KEY (role_aggregate_id)
            REFERENCES role_aggregates (id) ON DELETE CASCADE
    SQL
  end
end
