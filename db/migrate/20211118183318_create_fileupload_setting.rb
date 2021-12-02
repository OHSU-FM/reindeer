class CreateFileuploadSetting < ActiveRecord::Migration[6.1]
  def self.up
    create_table :fileupload_settings do |t|
      t.integer :permission_group_id
      t.string :code
      t.boolean :visible
      t.timestamps
    end
    add_index :fileupload_settings, [:permission_group_id, :code], unique: true
  end

  def self.down
    drop_table :fileupload_settings
  end
end
