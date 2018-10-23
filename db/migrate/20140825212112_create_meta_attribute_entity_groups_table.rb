class CreateMetaAttributeEntityGroupsTable < ActiveRecord::Migration[4.2]
  def change
    create_table :meta_attribute_entity_groups do |t|
        t.text :group_name, :unique=>true, :null=>false 
        t.text :parent_table, :null=>false
        t.boolean :visible, :default=>true
    end
  end
end
