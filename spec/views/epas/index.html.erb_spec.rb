require 'rails_helper'

RSpec.describe "epas/index", type: :view do
  before(:each) do
    assign(:epas, [
      Epa.create!(
        :submit_date => "Submit Date",
        :student_assessed => "Student Assessed",
        :epa => "Epa",
        :clinical_discipline => "Clinical Discipline",
        :clinical_setting => "Clinical Setting",
        :clincial_assessor => "Clincial Assessor"
      ),
      Epa.create!(
        :submit_date => "Submit Date",
        :student_assessed => "Student Assessed",
        :epa => "Epa",
        :clinical_discipline => "Clinical Discipline",
        :clinical_setting => "Clinical Setting",
        :clincial_assessor => "Clincial Assessor"
      )
    ])
  end

  it "renders a list of epas" do
    render
    assert_select "tr>td", :text => "Submit Date".to_s, :count => 2
    assert_select "tr>td", :text => "Student Assessed".to_s, :count => 2
    assert_select "tr>td", :text => "Epa".to_s, :count => 2
    assert_select "tr>td", :text => "Clinical Discipline".to_s, :count => 2
    assert_select "tr>td", :text => "Clinical Setting".to_s, :count => 2
    assert_select "tr>td", :text => "Clincial Assessor".to_s, :count => 2
  end
end
