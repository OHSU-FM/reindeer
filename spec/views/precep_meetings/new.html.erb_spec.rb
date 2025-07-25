require 'rails_helper'

RSpec.describe "precep_meetings/new", type: :view do
  before(:each) do
    assign(:precep_meeting, PrecepMeeting.new(
      student_sid: "MyString",
      student_name: "MyString",
      meeting_notes: "MyString",
      meeting_with: "MyString",
      other_present: "MyString"
    ))
  end

  it "renders new precep_meeting form" do
    render

    assert_select "form[action=?][method=?]", precep_meetings_path, "post" do

      assert_select "input[name=?]", "precep_meeting[student_sid]"

      assert_select "input[name=?]", "precep_meeting[student_name]"

      assert_select "input[name=?]", "precep_meeting[meeting_notes"

      assert_select "input[name=?]", "precep_meeting[meeting_with]"

      assert_select "input[name=?]", "precep_meeting[other_present]"
    end
  end
end
