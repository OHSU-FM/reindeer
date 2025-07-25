require 'rails_helper'

RSpec.describe "precep_meetings/show", type: :view do
  before(:each) do
    assign(:precep_meeting, PrecepMeeting.create!(
      student_sid: "Student Sid",
      student_name: "Student Name",
      meeting_notes.text: "Meeting Notes",
      meeting_with: "Meeting With",
      other_present: "Other Present"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Student Sid/)
    expect(rendered).to match(/Student Name/)
    expect(rendered).to match(/Meeting Notes/)
    expect(rendered).to match(/Meeting With/)
    expect(rendered).to match(/Other Present/)
  end
end
