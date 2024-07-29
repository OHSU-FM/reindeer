require 'rails_helper'

RSpec.describe "course_schedules/index", type: :view do
  before(:each) do
    assign(:course_schedules, [
      CourseSchedule.create!(
        course_schedule: "Course Schedule",
        no_of_seats: 2,
        comment: "Comment"
      ),
      CourseSchedule.create!(
        course_schedule: "Course Schedule",
        no_of_seats: 2,
        comment: "Comment"
      )
    ])
  end

  it "renders a list of course_schedules" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Course Schedule".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Comment".to_s), count: 2
  end
end
