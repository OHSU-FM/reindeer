require 'rails_helper'

RSpec.describe "epas/new", type: :view do
  before(:each) do
    assign(:epa, Epa.new(
      :submit_date => "MyString",
      :student_assessed => "MyString",
      :epa => "MyString",
      :clinical_discipline => "MyString",
      :clinical_setting => "MyString",
      :clincial_assessor => "MyString"
    ))
  end

  it "renders new epa form" do
    render

    assert_select "form[action=?][method=?]", epas_path, "post" do

      assert_select "input[name=?]", "epa[submit_date]"

      assert_select "input[name=?]", "epa[student_assessed]"

      assert_select "input[name=?]", "epa[epa]"

      assert_select "input[name=?]", "epa[clinical_discipline]"

      assert_select "input[name=?]", "epa[clinical_setting]"

      assert_select "input[name=?]", "epa[clincial_assessor]"
    end
  end
end
