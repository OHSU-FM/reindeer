require 'rails_helper'

RSpec.describe "new_competencies/index", type: :view do
  before(:each) do
    assign(:new_competencies, [
      NewCompetency.create!(
        user_id: 2,
        permission_group_id: 3,
        student_uid: "Student Uid",
        email: "Email",
        medhub_id: "Medhub",
        course_name: "Course Name"
      ),
      NewCompetency.create!(
        user_id: 2,
        permission_group_id: 3,
        student_uid: "Student Uid",
        email: "Email",
        medhub_id: "Medhub",
        course_name: "Course Name"
      )
    ])
  end

  it "renders a list of new_competencies" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Student Uid".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Medhub".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Course Name".to_s), count: 2
  end
end
