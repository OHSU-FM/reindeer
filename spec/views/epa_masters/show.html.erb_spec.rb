require 'rails_helper'

RSpec.describe "epa_masters/show", type: :view do
  before(:each) do
    @epa_master = assign(:epa_master, EpaMaster.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
