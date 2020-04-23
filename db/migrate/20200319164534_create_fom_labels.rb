class CreateFomLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :fom_labels do |t|
      t.integer :permission_group_id
      t.string :course_code
      t.json :labels
    end
    add_index :fom_labels, [:permission_group_id, :course_code], :unique => true, :name => 'by_permission_group_course_code'
  end
end
