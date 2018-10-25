class AddUserToArtifacts < ActiveRecord::Migration[5.2]
  def change
    add_reference :artifacts, :user, foreign_key: true
  end
end
