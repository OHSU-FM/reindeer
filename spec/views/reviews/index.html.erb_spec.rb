require 'rails_helper'

RSpec.describe "reviews/index", type: :view do
  before(:each) do
    assign(:reviews, [
      create(:review),
      create(:review)
    ])
  end

  it "should be successful" do
    render
    expect(controller.response).to be_success
  end

  it "renders a list of reviews" do
    render
    expect(rendered).to have_selector('h1', text: "Reviews")
  end
end
