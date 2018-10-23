class AddFieldsToMetaAttributeEntityGroups < ActiveRecord::Migration[4.2]
  def change
    add_column :meta_attribute_entity_groups, :parent_table_pk, :string
    add_column :meta_attribute_entities, :entity_type_fk, :string
  end
end
