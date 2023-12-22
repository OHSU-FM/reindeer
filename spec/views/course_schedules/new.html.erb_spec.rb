require 'rails_helper'

RSpec.describe "course_schedules/new", type: :view do
  before(:each) do
    assign(:course_schedule, CourseSchedule.new(
      course_schedule: "MyString",
      no_of_seats: 1,
      comment: "MyString"
    ))
  end

  it "renders new course_schedule form" do
    render

    assert_select "form[action=?][method=?]", course_schedules_path, "post" do

      assert_select "input[name=?]", "course_schedule[course_schedule]"

      assert_select "input[name=?]", "course_schedule[no_of_seats]"

      assert_select "input[name=?]", "course_schedule[comment]"
    end
  end
end
