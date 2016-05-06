class CreateUserResponses < ActiveRecord::Migration
  def change
    create_table :user_responses do |t|
      t.string :resp_type
      t.string :title
      t.string :category
      t.string :status, default: 0
      t.text :content
      t.references :user_assignment
    end
  end
end
