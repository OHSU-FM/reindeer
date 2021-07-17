require 'rails_helper'

RSpec.describe "fom_remeds/new", type: :view do
  before(:each) do
    assign(:fom_remed, FomRemed.new(
      user_id: 1,
      block: "MyString"
    ))
  end

  it "renders new fom_remed form" do
    render

    assert_select "form[action=?][method=?]", fom_remeds_path, "post" do

      assert_select "input[name=?]", "fom_remed[user_id]"

      assert_select "input[name=?]", "fom_remed[block]"
    end
  end
end
