class CreateUserExternals < ActiveRecord::Migration
  def change
    create_table :user_externals do |t|
        t.references :user, :null => false 
        t.string :ident, :null => false
        t.string :ident_type, :null => false
    end
    add_index(:user_externals, [:user_id])
  end
  
end
