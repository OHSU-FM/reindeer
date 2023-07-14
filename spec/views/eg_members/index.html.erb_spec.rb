require 'rails_helper'

RSpec.describe "eg_members/index", type: :view do
  before(:each) do
    assign(:eg_members, [
      EgMember.create!(
        full_name: "Full Name",
        email: "Email",
        eg_type: "Eg Type",
        active: false
      ),
      EgMember.create!(
        full_name: "Full Name",
        email: "Email",
        eg_type: "Eg Type",
        active: false
      )
    ])
  end

  it "renders a list of eg_members" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Full Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Eg Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
