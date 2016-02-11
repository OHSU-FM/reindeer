class NewPermissions < ActiveRecord::Migration
  def change
    create_table :permission_groups do |t|
       t.text :title, :null=>false, :unique=>true
       t.timestamps
    end

    create_table :permission_ls_groups do |t|
        t.integer :lime_survey_sid,   :null=>false
        t.references :permission_group, :null=>false
        t.boolean :enabled, :default=>false
        t.boolean :view_raw, :default=>false
        t.boolean :view_all, :default=>false
        t.timestamps
    end

    add_index :permission_ls_groups, [:lime_survey_sid, :permission_group_id], 
        :unique=>true, :name=>:uniq_sid_by_group
    
    create_table :permission_ls_group_filters do |t|
        t.references :permission_ls_group, :null=>false
        t.integer :lime_question_qid
        t.text :ident_type
        t.text :restricted_val
        t.boolean :filter_all, :default=>false
        t.timestamps
    end

    add_index :permission_ls_group_filters, [:permission_ls_group_id, :lime_question_qid], 
        :unique=>true, :name=>:uniq_qid_by_group

    add_column :user_externals, :use_email, :boolean, :default=>false

    add_column :users, :permission_group_id, :integer
    remove_column :role_aggregates, :managed_permissions, :boolean, :default=>false
  
    reversible do |change|
        change.up do
            change_column_null :user_externals, :ident, true
            if ActiveRecord::Base.connection.table_exists?(:user_lime_permissions)
                drop_table :user_lime_permissions
            end
            
            if UserExternal.column_names.include? 'filter_all'
                remove_column :user_externals, :filter_all, :boolean, :default=>true
            end
            
            if User.column_names.include? 'use_ldap'
                remove_column :users, :use_ldap, :boolean, :default=>false
            end
            
        end

    end

  end

end
