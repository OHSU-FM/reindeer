require 'rails_helper'

RSpec.describe "fom_remeds/edit", type: :view do
  before(:each) do
    @fom_remed = assign(:fom_remed, FomRemed.create!(
      user_id: 1,
      block: "MyString"
    ))
  end

  it "renders the edit fom_remed form" do
    render

    assert_select "form[action=?][method=?]", fom_remed_path(@fom_remed), "post" do

      assert_select "input[name=?]", "fom_remed[user_id]"

      assert_select "input[name=?]", "fom_remed[block]"
    end
  end
end
