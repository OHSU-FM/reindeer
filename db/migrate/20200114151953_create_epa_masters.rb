class CreateEpaMasters < ActiveRecord::Migration[5.2]
  def up
    create_table :epa_masters do |t|
      t.string   :epa
      t.string   :status
      t.datetime :status_date
      t.datetime :expiration_date
      t.references :user, foreign_key: true
      t.timestamps
    end
    def down
      drop_table :epa_masters
    end
    add_index :epa_masters, [:user_id, :epa], :unique => true, :name => 'by_user_epas'
  end
end
