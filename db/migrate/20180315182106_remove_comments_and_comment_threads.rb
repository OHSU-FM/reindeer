class RemoveCommentsAndCommentThreads < ActiveRecord::Migration[5.0]
  def self.up
    drop_table :comments
    drop_table :comment_threads
  end

  def self.down
    drop_table :comment_threads do |t|
      t.string :threadable_type
      t.integer :threadable_id
      t.integer :first_user_id, :null => false
      t.integer :second_user_id, :null => false

      t.timestamps null: false
    end

    create_table :comments, :force => true do |t|
      t.integer :commentable_id
      t.string :commentable_type
      t.text :body
      t.string :flagged_as
      t.integer :user_id, :null => false
      t.timestamps
    end

    add_index :comments, :user_id
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
