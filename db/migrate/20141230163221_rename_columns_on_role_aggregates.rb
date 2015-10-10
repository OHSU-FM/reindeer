class RenameColumnsOnRoleAggregates < ActiveRecord::Migration
    ##
    # Add fields to role_aggregates project
    def change
        rename_column :role_aggregates, :email_fieldname, :pk_fieldname
        rename_column :role_aggregates, :title, :pk_title_fieldname
        add_column :role_aggregates, :pk_label, :string
        add_column :role_aggregates, :agg_label, :string
        add_column :role_aggregates, :agg_title_fieldname, :string
    end
end
