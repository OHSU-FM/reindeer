class AddIsLdapToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_ldap, :boolean, :default=>false
  end
end
