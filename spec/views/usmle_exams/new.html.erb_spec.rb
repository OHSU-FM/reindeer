require 'rails_helper'

RSpec.describe "usmle_exams/new", type: :view do
  before(:each) do
    assign(:usmle_exam, UsmleExam.new(
      :user.references => "MyString",
      :exam_type => "MyString",
      :no_attempts => 1,
      :pass_fail => "MyString",
      :exam_score => 1
    ))
  end

  it "renders new usmle_exam form" do
    render

    assert_select "form[action=?][method=?]", usmle_exams_path, "post" do

      assert_select "input[name=?]", "usmle_exam[user.references]"

      assert_select "input[name=?]", "usmle_exam[exam_type]"

      assert_select "input[name=?]", "usmle_exam[no_attempts]"

      assert_select "input[name=?]", "usmle_exam[pass_fail]"

      assert_select "input[name=?]", "usmle_exam[exam_score]"
    end
  end
end
