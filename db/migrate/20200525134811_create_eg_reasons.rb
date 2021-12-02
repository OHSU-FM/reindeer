class CreateEgReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :eg_reasons do |t|
      t.string :reason
      t.timestamps
    end
  end
end
