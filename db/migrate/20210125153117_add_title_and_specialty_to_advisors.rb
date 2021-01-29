class AddTitleAndSpecialtyToAdvisors < ActiveRecord::Migration[5.2]
  def change
    add_column :advisors, :title, :string
    add_column :advisors, :specialty, :string
  end
end
