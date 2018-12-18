require 'rails_helper'

RSpec.describe "epas/show", type: :view do
  before(:each) do
    @epa = assign(:epa, Epa.create!(
      :submit_date => "Submit Date",
      :student_assessed => "Student Assessed",
      :epa => "Epa",
      :clinical_discipline => "Clinical Discipline",
      :clinical_setting => "Clinical Setting",
      :clincial_assessor => "Clincial Assessor"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Submit Date/)
    expect(rendered).to match(/Student Assessed/)
    expect(rendered).to match(/Epa/)
    expect(rendered).to match(/Clinical Discipline/)
    expect(rendered).to match(/Clinical Setting/)
    expect(rendered).to match(/Clincial Assessor/)
  end
end
