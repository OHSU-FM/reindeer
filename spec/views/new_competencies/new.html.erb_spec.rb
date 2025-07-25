require 'rails_helper'

RSpec.describe "new_competencies/new", type: :view do
  before(:each) do
    assign(:new_competency, NewCompetency.new(
      user_id: 1,
      permission_group_id: 1,
      student_uid: "MyString",
      email: "MyString",
      medhub_id: "MyString",
      course_name: "MyString"
    ))
  end

  it "renders new new_competency form" do
    render

    assert_select "form[action=?][method=?]", new_competencies_path, "post" do

      assert_select "input[name=?]", "new_competency[user_id]"

      assert_select "input[name=?]", "new_competency[permission_group_id]"

      assert_select "input[name=?]", "new_competency[student_uid]"

      assert_select "input[name=?]", "new_competency[email]"

      assert_select "input[name=?]", "new_competency[medhub_id]"

      assert_select "input[name=?]", "new_competency[course_name]"
    end
  end
end
