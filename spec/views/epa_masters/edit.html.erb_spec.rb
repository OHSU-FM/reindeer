require 'rails_helper'

RSpec.describe "epa_masters/edit", type: :view do
  before(:each) do
    @epa_master = assign(:epa_master, EpaMaster.create!())
  end

  it "renders the edit epa_master form" do
    render

    assert_select "form[action=?][method=?]", epa_master_path(@epa_master), "post" do
    end
  end
end
