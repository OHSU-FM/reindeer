require 'rails_helper'

RSpec.describe "courses/index", type: :view do
  before(:each) do
    assign(:courses, [
      Course.create!(
        course_number: "Course Number",
        course_name: "Course Name",
        content_type: "Content Type",
        medhub_course_id: 2,
        rural: false
      ),
      Course.create!(
        course_number: "Course Number",
        course_name: "Course Name",
        content_type: "Content Type",
        medhub_course_id: 2,
        rural: false
      )
    ])
  end

  it "renders a list of courses" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Course Number".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Course Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Content Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
