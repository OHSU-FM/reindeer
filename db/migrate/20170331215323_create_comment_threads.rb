class CreateCommentThreads < ActiveRecord::Migration
  def change
    create_table :comment_threads do |t|
      t.string :threadable_type
      t.integer :threadable_id
      t.integer :first_user_id, :null => false
      t.integer :second_user_id, :null => false

      t.timestamps null: false
    end
  end
end
