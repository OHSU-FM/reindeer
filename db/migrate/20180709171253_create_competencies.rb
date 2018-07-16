class CreateCompetencies < ActiveRecord::Migration[5.0]
  def change
    create_table :competencies do |t|
      t.integer :user_id
      t.string :student_uid
      t.string :student_name
      t.string :email
      t.string :student_year
      t.decimal :ics,  :precision => 5, :scale => 2
      t.decimal :mk,  :precision => 5, :scale => 2
      t.decimal :pbli,  :precision => 5, :scale => 2
      t.decimal :pcp,  :precision => 5, :scale => 2
      t.decimal :pppd,  :precision => 5, :scale => 2
      t.decimal :sbpic,  :precision => 5, :scale => 2
      t.decimal :ics1,  :precision => 5, :scale => 2
      t.decimal :ics2,  :precision => 5, :scale => 2
      t.decimal :ics3,  :precision => 5, :scale => 2
      t.decimal :ics4,  :precision => 5, :scale => 2
      t.decimal :ics5,  :precision => 5, :scale => 2
      t.decimal :ics6,  :precision => 5, :scale => 2
      t.decimal :ics7,  :precision => 5, :scale => 2
      t.decimal :ics8,  :precision => 5, :scale => 2
      t.decimal :mk1,  :precision => 5, :scale => 2
      t.decimal :mk2,  :precision => 5, :scale => 2
      t.decimal :mk3,  :precision => 5, :scale => 2
      t.decimal :mk4,  :precision => 5, :scale => 2
      t.decimal :mk5,  :precision => 5, :scale => 2
      t.decimal :pbli1,  :precision => 5, :scale => 2
      t.decimal :pbli2,  :precision => 5, :scale => 2
      t.decimal :pbli3,  :precision => 5, :scale => 2
      t.decimal :pbli4,  :precision => 5, :scale => 2
      t.decimal :pbli5,  :precision => 5, :scale => 2
      t.decimal :pbli6,  :precision => 5, :scale => 2
      t.decimal :pbli7,  :precision => 5, :scale => 2
      t.decimal :pbli8,  :precision => 5, :scale => 2
      t.decimal :pcp1,  :precision => 5, :scale => 2
      t.decimal :pcp2,  :precision => 5, :scale => 2
      t.decimal :pcp3,  :precision => 5, :scale => 2
      t.decimal :pcp4,  :precision => 5, :scale => 2
      t.decimal :pcp5,  :precision => 5, :scale => 2
      t.decimal :pcp6,  :precision => 5, :scale => 2
      t.decimal :pppd1,  :precision => 5, :scale => 2
      t.decimal :pppd2,  :precision => 5, :scale => 2
      t.decimal :pppd3,  :precision => 5, :scale => 2
      t.decimal :pppd4,  :precision => 5, :scale => 2
      t.decimal :pppd5,  :precision => 5, :scale => 2
      t.decimal :pppd6,  :precision => 5, :scale => 2
      t.decimal :pppd7,  :precision => 5, :scale => 2
      t.decimal :pppd8,  :precision => 5, :scale => 2
      t.decimal :pppd9,  :precision => 5, :scale => 2
      t.decimal :pppd10,  :precision => 5, :scale => 2
      t.decimal :pppd11,  :precision => 5, :scale => 2
      t.decimal :sbpic1,  :precision => 5, :scale => 2
      t.decimal :sbpic2,  :precision => 5, :scale => 2
      t.decimal :sbpic3,  :precision => 5, :scale => 2
      t.decimal :sbpic4,  :precision => 5, :scale => 2
      t.decimal :sbpic5,  :precision => 5, :scale => 2
      t.timestamps
    end
    add_index :competencies, :user_id
    add_index :competencies, :student_uid
  end
end
