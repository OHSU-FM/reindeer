class AddpermissionGroupIdFomExams < ActiveRecord::Migration[5.2]
  def change
    add_column :fom_exams, :permission_group_id, :integer
    remove_index :fom_exams, :unique => true, :name => 'by_user_course_code'
    add_index :fom_exams, [:user_id, :permission_group_id, :course_code], :unique => true, :name => 'by_user_permission_group_course_code'
  end

end
