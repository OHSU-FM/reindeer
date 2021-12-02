require 'rails_helper'

RSpec.describe "usmle_exams/edit", type: :view do
  before(:each) do
    @usmle_exam = assign(:usmle_exam, UsmleExam.create!(
      :user.references => "MyString",
      :exam_type => "MyString",
      :no_attempts => 1,
      :pass_fail => "MyString",
      :exam_score => 1
    ))
  end

  it "renders the edit usmle_exam form" do
    render

    assert_select "form[action=?][method=?]", usmle_exam_path(@usmle_exam), "post" do

      assert_select "input[name=?]", "usmle_exam[user.references]"

      assert_select "input[name=?]", "usmle_exam[exam_type]"

      assert_select "input[name=?]", "usmle_exam[no_attempts]"

      assert_select "input[name=?]", "usmle_exam[pass_fail]"

      assert_select "input[name=?]", "usmle_exam[exam_score]"
    end
  end
end
