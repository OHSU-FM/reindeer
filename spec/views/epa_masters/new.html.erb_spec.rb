require 'rails_helper'

RSpec.describe "epa_masters/new", type: :view do
  before(:each) do
    assign(:epa_master, EpaMaster.new())
  end

  it "renders new epa_master form" do
    render

    assert_select "form[action=?][method=?]", epa_masters_path, "post" do
    end
  end
end
