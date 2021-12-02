class AddAdvisorDiscussedToMeetingss < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :advisor_discussed, :text, array: true, default: []
    add_column :meetings, :advisor_outcomes, :text, array: true, default: []
  end
end
