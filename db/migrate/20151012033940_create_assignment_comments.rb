class CreateAssignmentComments < ActiveRecord::Migration
  def change
    create_table :assignment_comments do |t|
      t.references :user_assignment, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.text :slug

      t.timestamps null: false
    end
  end
end
