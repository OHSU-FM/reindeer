class CreateCohorts < ActiveRecord::Migration[4.2]
  def up
    create_table :cohorts do |t|
      t.references :user, index: true, foreign_key: true
      t.references :permission_group, index: true
      t.string :title

      t.timestamps null: false
    end
  
    change_table :users do |t|
      t.belongs_to :cohort
    end
  end

  def down
    drop_table :cohorts

    change_table :users do |t|
      t.remove :cohort_id
    end
  end
end
