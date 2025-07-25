require 'rails_helper'

RSpec.describe "new_competencies/edit", type: :view do
  let(:new_competency) {
    NewCompetency.create!(
      user_id: 1,
      permission_group_id: 1,
      student_uid: "MyString",
      email: "MyString",
      medhub_id: "MyString",
      course_name: "MyString"
    )
  }

  before(:each) do
    assign(:new_competency, new_competency)
  end

  it "renders the edit new_competency form" do
    render

    assert_select "form[action=?][method=?]", new_competency_path(new_competency), "post" do

      assert_select "input[name=?]", "new_competency[user_id]"

      assert_select "input[name=?]", "new_competency[permission_group_id]"

      assert_select "input[name=?]", "new_competency[student_uid]"

      assert_select "input[name=?]", "new_competency[email]"

      assert_select "input[name=?]", "new_competency[medhub_id]"

      assert_select "input[name=?]", "new_competency[course_name]"
    end
  end
end
