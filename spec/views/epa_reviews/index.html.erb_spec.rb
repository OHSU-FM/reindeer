require 'rails_helper'

RSpec.describe "epa_reviews/index", type: :view do
  before(:each) do
    assign(:epa_reviews, [
      EpaReview.create!(),
      EpaReview.create!()
    ])
  end

  it "renders a list of epa_reviews" do
    render
  end
end
