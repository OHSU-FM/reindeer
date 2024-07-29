require 'rails_helper'

RSpec.describe "course_schedules/show", type: :view do
  before(:each) do
    assign(:course_schedule, CourseSchedule.create!(
      course_schedule: "Course Schedule",
      no_of_seats: 2,
      comment: "Comment"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Course Schedule/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Comment/)
  end
end
