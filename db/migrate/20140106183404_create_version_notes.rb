class CreateVersionNotes < ActiveRecord::Migration[4.2]
  def change
    create_table :version_notes do |t|
      t.text :note      
      t.timestamps
    end

    # Also add a column to the version table
    add_column :versions, :version_note_id, :integer
    add_index :versions, :version_note_id


  end
end
