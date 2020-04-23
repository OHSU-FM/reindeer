require 'rails_helper'

RSpec.describe "artifacts/edit", type: :view do
  before(:each) do
    @artifact = assign(:artifact, Artifact.create!(
      :tittle => "MyString",
      :content => "MyText"
    ))
  end

  it "renders the edit artifact form" do
    render

    assert_select "form[action=?][method=?]", artifact_path(@artifact), "post" do

      assert_select "input[name=?]", "artifact[tittle]"

      assert_select "textarea[name=?]", "artifact[content]"
    end
  end
end
