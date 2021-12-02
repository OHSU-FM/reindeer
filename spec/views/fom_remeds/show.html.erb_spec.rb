require 'rails_helper'

RSpec.describe "fom_remeds/show", type: :view do
  before(:each) do
    @fom_remed = assign(:fom_remed, FomRemed.create!(
      user_id: 2,
      block: "Block"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Block/)
  end
end
