require 'rails_helper'

RSpec.describe "courses/edit", type: :view do
  let(:course) {
    Course.create!(
      course_number: "MyString",
      course_name: "MyString",
      content_type: "MyString",
      medhub_course_id: 1,
      rural: false
    )
  }

  before(:each) do
    assign(:course, course)
  end

  it "renders the edit course form" do
    render

    assert_select "form[action=?][method=?]", course_path(course), "post" do

      assert_select "input[name=?]", "course[course_number]"

      assert_select "input[name=?]", "course[course_name]"

      assert_select "input[name=?]", "course[content_type]"

      assert_select "input[name=?]", "course[medhub_course_id]"

      assert_select "input[name=?]", "course[rural]"
    end
  end
end
