class CreateCohorts < ActiveRecord::Migration
  def up
    create_table :cohorts do |t|
      t.references :user, index: true, foreign_key: true
      t.references :permission_group, index: true
      t.string :title

      t.timestamps null: false
    end

    change_table :assignment_groups do |t|
      t.remove :user_id
      t.remove :user_ids
      t.references :cohort, index: true
    end

    change_table :assignment_group_templates do |t|
      t.remove :permission_group_ids
      t.remove :permission_group_id
    end

    change_table :users do |t|
      t.belongs_to :cohort
    end
  end

  def down
    drop_table :cohorts

    change_table :assignment_groups do |t|
      t.references :user, index: true, foreign_key: true
      t.text :user_ids
      t.remove :cohort_id
    end

    change_table :assignment_group_templates do |t|
      t.references :permission_group, index: true
      t.text :permission_group_ids
    end

    change_table :users do |t|
      t.remove :cohort_id
    end
  end
end
