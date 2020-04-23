require 'rails_helper'

RSpec.describe "artifacts/index", type: :view do
  before(:each) do
    assign(:artifacts, [
      Artifact.create!(
        :tittle => "Tittle",
        :content => "MyText"
      ),
      Artifact.create!(
        :tittle => "Tittle",
        :content => "MyText"
      )
    ])
  end

  it "renders a list of artifacts" do
    render
    assert_select "tr>td", :text => "Tittle".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
