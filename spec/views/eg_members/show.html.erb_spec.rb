require 'rails_helper'

RSpec.describe "eg_members/show", type: :view do
  before(:each) do
    assign(:eg_member, EgMember.create!(
      full_name: "Full Name",
      email: "Email",
      eg_type: "Eg Type",
      active: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Full Name/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Eg Type/)
    expect(rendered).to match(/false/)
  end
end
