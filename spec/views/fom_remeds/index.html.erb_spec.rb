require 'rails_helper'

RSpec.describe "fom_remeds/index", type: :view do
  before(:each) do
    assign(:fom_remeds, [
      FomRemed.create!(
        user_id: 2,
        block: "Block"
      ),
      FomRemed.create!(
        user_id: 2,
        block: "Block"
      )
    ])
  end

  it "renders a list of fom_remeds" do
    render
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: "Block".to_s, count: 2
  end
end
