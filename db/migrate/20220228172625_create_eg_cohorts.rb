class CreateEgCohorts < ActiveRecord::Migration[6.1]
  def change
    create_table :eg_cohorts do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :permission_group_id
      t.string :email
      t.string :eg_full_name1
      t.string :eg_email1
      t.string :eg_full_name2
      t.string :eg_email2
      t.timestamps
    end
  end
end
