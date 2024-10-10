class RemoveIndexNewCompetency < ActiveRecord::Migration[7.2]
  def change
     remove_index :new_competencies, [:permission_group_id, :user_id]
     add_index :new_competencies, [:permission_group_id, :user_id, :id], :unique => true
  end
end
