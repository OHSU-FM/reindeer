class CreateDataMigrationsTable < ActiveRecord::Migration[4.2]
  def change
    create_table :data_migrations do |t|
        t.text :version, :null=>false
    end
  end
end
