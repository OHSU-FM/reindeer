class AddMatriculatedDateToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :matriculated_date, :date
  end
end
