class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.belongs_to :user

      t.timestamps null: false
    end

    add_index :reviews, :user_id, unique: true
  end
end
