class RenameCommentSlugToSlugMd < ActiveRecord::Migration
  def change
    rename_column :assignment_comments, :slug, :slug_md
  end
end
