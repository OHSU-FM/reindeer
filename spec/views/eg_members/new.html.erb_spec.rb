require 'rails_helper'

RSpec.describe "eg_members/new", type: :view do
  before(:each) do
    assign(:eg_member, EgMember.new(
      full_name: "MyString",
      email: "MyString",
      eg_type: "MyString",
      active: false
    ))
  end

  it "renders new eg_member form" do
    render

    assert_select "form[action=?][method=?]", eg_members_path, "post" do

      assert_select "input[name=?]", "eg_member[full_name]"

      assert_select "input[name=?]", "eg_member[email]"

      assert_select "input[name=?]", "eg_member[eg_type]"

      assert_select "input[name=?]", "eg_member[active]"
    end
  end
end
