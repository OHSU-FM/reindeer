require 'rails_helper'

RSpec.describe "epa_masters/index", type: :view do
  before(:each) do
    assign(:epa_masters, [
      EpaMaster.create!(),
      EpaMaster.create!()
    ])
  end

  it "renders a list of epa_masters" do
    render
  end
end
