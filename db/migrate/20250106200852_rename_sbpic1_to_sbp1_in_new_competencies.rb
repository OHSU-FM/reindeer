class RenameSbpic1ToSbp1InNewCompetencies < ActiveRecord::Migration[7.2]
  def change
    rename_column :new_competencies, :sbpic1, :sbp1
  end
  # def up
  #   rename_column :new_competencies, :sbpic1, :sbp1
  # end
  #
  # def down
  #   rename_column :new_competencies, :sbp1, :sbpic1
  # end

end
