class DropEpaMasters < ActiveRecord::Migration[5.2]
  def change
	   drop_table :epa_masters
  end
end
