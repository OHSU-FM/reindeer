require 'rails_helper'

RSpec.describe "badging_dates/edit", type: :view do
  let(:badging_date) {
    BadgingDate.create!(
      permission_group_id: 1
    )
  }

  before(:each) do
    assign(:badging_date, badging_date)
  end

  it "renders the edit badging_date form" do
    render

    assert_select "form[action=?][method=?]", badging_date_path(badging_date), "post" do

      assert_select "input[name=?]", "badging_date[permission_group_id]"
    end
  end
end
