require 'rails_helper'

RSpec.describe "eg_members/edit", type: :view do
  let(:eg_member) {
    EgMember.create!(
      full_name: "MyString",
      email: "MyString",
      eg_type: "MyString",
      active: false
    )
  }

  before(:each) do
    assign(:eg_member, eg_member)
  end

  it "renders the edit eg_member form" do
    render

    assert_select "form[action=?][method=?]", eg_member_path(eg_member), "post" do

      assert_select "input[name=?]", "eg_member[full_name]"

      assert_select "input[name=?]", "eg_member[email]"

      assert_select "input[name=?]", "eg_member[eg_type]"

      assert_select "input[name=?]", "eg_member[active]"
    end
  end
end
