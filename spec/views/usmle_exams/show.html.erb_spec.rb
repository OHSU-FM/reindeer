require 'rails_helper'

RSpec.describe "usmle_exams/show", type: :view do
  before(:each) do
    @usmle_exam = assign(:usmle_exam, UsmleExam.create!(
      :user.references => "User.References",
      :exam_type => "Exam Type",
      :no_attempts => 2,
      :pass_fail => "Pass Fail",
      :exam_score => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/User.References/)
    expect(rendered).to match(/Exam Type/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Pass Fail/)
    expect(rendered).to match(/3/)
  end
end
