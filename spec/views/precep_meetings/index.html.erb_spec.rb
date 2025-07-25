require 'rails_helper'

RSpec.describe "precep_meetings/index", type: :view do
  before(:each) do
    assign(:precep_meetings, [
      PrecepMeeting.create!(
        student_sid: "Student Sid",
        student_name: "Student Name",
        meeting_notes.text: "Meeting Notes",
        meeting_with: "Meeting With",
        other_present: "Other Present"
      ),
      PrecepMeeting.create!(
        student_sid: "Student Sid",
        student_name: "Student Name",
        meeting_notes.text: "Meeting Notes",
        meeting_with: "Meeting With",
        other_present: "Other Present"
      )
    ])
  end

  it "renders a list of precep_meetings" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Student Sid".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Student Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Meeting Notes".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Meeting With".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Other Present".to_s), count: 2
  end
end
