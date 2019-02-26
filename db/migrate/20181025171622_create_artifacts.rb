class CreateArtifacts < ActiveRecord::Migration[5.2]
  def change
    create_table :artifacts do |t|
      t.string :tittle
      t.text :content

      t.timestamps
    end
  end
end
