require 'rails_helper'

RSpec.describe "courses/show", type: :view do
  before(:each) do
    assign(:course, Course.create!(
      course_number: "Course Number",
      course_name: "Course Name",
      content_type: "Content Type",
      medhub_course_id: 2,
      rural: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Course Number/)
    expect(rendered).to match(/Course Name/)
    expect(rendered).to match(/Content Type/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
  end
end
