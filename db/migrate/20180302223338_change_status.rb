class ChangeStatus < ActiveRecord::Migration[5.0]
  def change
    rename_column :goals, :status, :g_status
    rename_column :meetings, :status, :m_status
    rename_column :rooms, :the_name_of_it, :identifier
  end
end
