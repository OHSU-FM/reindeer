class AddFormalNameToAdvisors < ActiveRecord::Migration[8.0]
  def change
    add_column :advisors, :formal_name, :string
    add_column :advisors, :brief_cv, :text
  end
end
