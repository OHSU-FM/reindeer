require 'rails_helper'

RSpec.describe "badging_dates/show", type: :view do
  before(:each) do
    assign(:badging_date, BadgingDate.create!(
      permission_group_id: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
  end
end
