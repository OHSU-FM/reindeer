class CreateAssignmentGroupTemplates < ActiveRecord::Migration
  def change
    create_table :assignment_group_templates do |t|
      t.references :permission_group, index: true
      t.string :title
      t.text :permission_group_ids
      t.text :sids
      t.text :desc_md
      t.boolean :active, default: true
      t.timestamps null: false
    end
  end
end
