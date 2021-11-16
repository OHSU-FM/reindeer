class AddStudyResourcesToMeetings < ActiveRecord::Migration[6.1]
  def change
    add_column :meetings, :study_resources, :text, array: true, default: []
    add_column :meetings, :study_resources_other, :string
  end
end
