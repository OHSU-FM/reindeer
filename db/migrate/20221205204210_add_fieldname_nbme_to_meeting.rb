class AddFieldnameNbmeToMeeting < ActiveRecord::Migration[6.1]
  def change
    add_column :meetings, :nbme_form, :json
    add_column :meetings, :uworld_info, :json
    add_column :meetings, :qbank_info, :json
  end
end
