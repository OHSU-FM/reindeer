class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.references :review, index: true
      t.references :sourceable, :polymorphic => true

      t.timestamps null: false
    end
  end
end
