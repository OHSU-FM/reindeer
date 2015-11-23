class CreateAssignmentGroups < ActiveRecord::Migration
  def change
    create_table :assignment_groups do |t|
      t.references :user, index: true, foreign_key: true
      t.references :assignment_group_template, index: true, foreign_key: true
      t.string :title
      t.integer :status
      t.text :desc_md
      t.text :user_ids
      t.timestamps null: false
    end
    add_reference :assignment_comments, :assignment_group, 
      index: true, foreign_key: true

  end
end
