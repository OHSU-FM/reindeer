class CreatePreceptorAssesses < ActiveRecord::Migration[5.2]
  def change
    create_table :preceptor_assesses do |t|
      t.references :user, foreign_key: true
      t.string  :response_id
      t.string  :preceptor_name
      t.string  :preceptor_email
      t.date    :submit_date
      t.string  :term
      t.string  :grade
      t.boolean :attribute1
      t.text    :attribute1_no
      t.boolean :attribute2
      t.text    :attribute2_no
      t.boolean :attribute3
      t.text    :attribute3_no
      t.text    :overall_performance
      t.text    :feedback
      t.string  :professional_concerns
      t.string  :concern_comments
      t.timestamps
    end
    add_index :preceptor_assesses, :response_id
  end
end
