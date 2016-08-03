class DropAssignmentComments < ActiveRecord::Migration
  def up
    drop_table :assignment_comments
  end

  def down
    create_table :assignment_comments do |t|
      t.references :user_assignment, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.text :md_slug
      t.timestamps null: false
    end
  end
end
