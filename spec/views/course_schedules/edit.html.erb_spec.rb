require 'rails_helper'

RSpec.describe "course_schedules/edit", type: :view do
  let(:course_schedule) {
    CourseSchedule.create!(
      course_schedule: "MyString",
      no_of_seats: 1,
      comment: "MyString"
    )
  }

  before(:each) do
    assign(:course_schedule, course_schedule)
  end

  it "renders the edit course_schedule form" do
    render

    assert_select "form[action=?][method=?]", course_schedule_path(course_schedule), "post" do

      assert_select "input[name=?]", "course_schedule[course_schedule]"

      assert_select "input[name=?]", "course_schedule[no_of_seats]"

      assert_select "input[name=?]", "course_schedule[comment]"
    end
  end
end
