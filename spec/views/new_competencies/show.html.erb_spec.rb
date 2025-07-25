require 'rails_helper'

RSpec.describe "new_competencies/show", type: :view do
  before(:each) do
    assign(:new_competency, NewCompetency.create!(
      user_id: 2,
      permission_group_id: 3,
      student_uid: "Student Uid",
      email: "Email",
      medhub_id: "Medhub",
      course_name: "Course Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Student Uid/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Medhub/)
    expect(rendered).to match(/Course Name/)
  end
end
