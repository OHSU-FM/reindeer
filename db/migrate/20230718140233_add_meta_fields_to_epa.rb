class AddMetaFieldsToEpa < ActiveRecord::Migration[7.0]
  def change
    add_column :epas, :meta_browser, :string
    add_column :epas, :meta_os, :string
    add_column :epas, :meta_device, :string
    add_column :epas, :meta_screen_size, :string
  end
end
