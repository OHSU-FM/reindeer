class FixColumnNameInArtifacts < ActiveRecord::Migration[5.2]
  def change
	rename_column :artifacts, :tittle, :title
  end
end
