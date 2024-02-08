require 'rails_helper'

RSpec.describe "badging_dates/index", type: :view do
  before(:each) do
    assign(:badging_dates, [
      BadgingDate.create!(
        permission_group_id: 2
      ),
      BadgingDate.create!(
        permission_group_id: 2
      )
    ])
  end

  it "renders a list of badging_dates" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
  end
end
