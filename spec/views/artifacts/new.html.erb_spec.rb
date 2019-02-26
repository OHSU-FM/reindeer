require 'rails_helper'

RSpec.describe "artifacts/new", type: :view do
  before(:each) do
    assign(:artifact, Artifact.new(
      :tittle => "MyString",
      :content => "MyText"
    ))
  end

  it "renders new artifact form" do
    render

    assert_select "form[action=?][method=?]", artifacts_path, "post" do

      assert_select "input[name=?]", "artifact[tittle]"

      assert_select "textarea[name=?]", "artifact[content]"
    end
  end
end
