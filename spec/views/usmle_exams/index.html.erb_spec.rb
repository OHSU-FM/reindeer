require 'rails_helper'

RSpec.describe "usmle_exams/index", type: :view do
  before(:each) do
    assign(:usmle_exams, [
      UsmleExam.create!(
        :user.references => "User.References",
        :exam_type => "Exam Type",
        :no_attempts => 2,
        :pass_fail => "Pass Fail",
        :exam_score => 3
      ),
      UsmleExam.create!(
        :user.references => "User.References",
        :exam_type => "Exam Type",
        :no_attempts => 2,
        :pass_fail => "Pass Fail",
        :exam_score => 3
      )
    ])
  end

  it "renders a list of usmle_exams" do
    render
    assert_select "tr>td", :text => "User.References".to_s, :count => 2
    assert_select "tr>td", :text => "Exam Type".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Pass Fail".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
