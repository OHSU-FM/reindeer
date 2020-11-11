class CreateAdvisors < ActiveRecord::Migration[5.2]
  def change
    create_table :advisors do |t|
      t.string :type
      t.string :name
      t.string :email
      t.string :status

      t.timestamps
    end
  end
end
