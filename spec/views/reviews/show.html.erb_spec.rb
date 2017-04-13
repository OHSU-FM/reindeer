require 'rails_helper'

RSpec.describe "reviews/show", type: :view do
  before(:each) do
    @review = assign(:review, create(:review))
  end

  it "should be successful" do
    render
    expect(controller.response).to be_success
  end

  it "renders full_name of user under review" do
    render
    expect(rendered).to have_selector('h1', text: @review.user.full_name)
  end
end
