class CreateActionPlanItems < ActiveRecord::Migration
  def change
    create_table :action_plan_items do |t|
      t.text :description
      t.references :goal
      
      t.timestamps null: false
    end
  end
end
