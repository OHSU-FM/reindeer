class CreateAssignmentGroupTemplates < ActiveRecord::Migration
  def change
    create_table :assignment_group_templates do |t|
      t.string :title
      t.array :sids
      t.text :desc_md

      t.timestamps null: false
    end
  end
end
