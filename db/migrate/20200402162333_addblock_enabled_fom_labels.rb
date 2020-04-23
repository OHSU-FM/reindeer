class AddblockEnabledFomLabels < ActiveRecord::Migration[5.2]
  def change
      add_column :fom_labels, :block_enabled, :boolean
  end
end
