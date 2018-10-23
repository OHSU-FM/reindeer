class CreateRoleAggregates < ActiveRecord::Migration[4.2]
  def change
    create_table :role_aggregates do |t|
      t.string :email_fieldname
      t.references :user
      t.integer :lime_survey_sid
      t.text :agg_fieldname
      t.text :title
      t.timestamps
    end
  end
end
