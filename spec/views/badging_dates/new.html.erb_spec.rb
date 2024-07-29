require 'rails_helper'

RSpec.describe "badging_dates/new", type: :view do
  before(:each) do
    assign(:badging_date, BadgingDate.new(
      permission_group_id: 1
    ))
  end

  it "renders new badging_date form" do
    render

    assert_select "form[action=?][method=?]", badging_dates_path, "post" do

      assert_select "input[name=?]", "badging_date[permission_group_id]"
    end
  end
end
