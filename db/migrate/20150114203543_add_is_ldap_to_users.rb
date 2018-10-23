class AddIsLdapToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :is_ldap, :boolean, :default=>false
  end
end
