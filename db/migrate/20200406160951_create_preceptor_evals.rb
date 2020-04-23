class CreatePreceptorEvals < ActiveRecord::Migration[5.2]
  def change
    create_table :preceptor_evals do |t|
      t.references :user, foreign_key: true
      t.integer :permission_group_id
      t.integer :ics1, :limit => 1 #tinyint
      t.integer :ics2, :limit => 1 #tinyint
      t.integer :ics4, :limit => 1 #tinyint
      t.integer :ics6, :limit => 1 #tinyint
      t.integer :ics7, :limit => 1 #tinyint
      t.integer :pbli1, :limit => 1 #tinyint
      t.integer :pbli8, :limit => 1 #tinyint
      t.integer :pppd1, :limit => 1 #tinyint
      t.integer :pppd2, :limit => 1 #tinyint
      t.integer :pppd6, :limit => 1 #tinyint
      t.integer :pppd9, :limit => 1 #tinyint
      t.integer :sbpic2, :limit => 1 #tinyint
      t.integer :sbpic4, :limit => 1 #tinyint
      t.integer :sbpic5, :limit => 1 #tinyint
      t.string  :preceptor_name
      t.date    :submit_date
      t.string  :term
      t.string  :grade
      t.string  :professional_concerns
      t.string  :concern_comments
      t.text    :mspe_comments
      t.text    :comments
      t.timestamps
    end
    add_index :preceptor_evals, [:user_id, :permission_group_id], :name => 'by_user_permission_group_id'
  end

end
