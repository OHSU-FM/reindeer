require 'rails_helper'

RSpec.describe "artifacts/show", type: :view do
  before(:each) do
    @artifact = assign(:artifact, Artifact.create!(
      :tittle => "Tittle",
      :content => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Tittle/)
    expect(rendered).to match(/MyText/)
  end
end
