require 'rails_helper'

RSpec.describe "courses/new", type: :view do
  before(:each) do
    assign(:course, Course.new(
      course_number: "MyString",
      course_name: "MyString",
      content_type: "MyString",
      medhub_course_id: 1,
      rural: false
    ))
  end

  it "renders new course form" do
    render

    assert_select "form[action=?][method=?]", courses_path, "post" do

      assert_select "input[name=?]", "course[course_number]"

      assert_select "input[name=?]", "course[course_name]"

      assert_select "input[name=?]", "course[content_type]"

      assert_select "input[name=?]", "course[medhub_course_id]"

      assert_select "input[name=?]", "course[rural]"
    end
  end
end
