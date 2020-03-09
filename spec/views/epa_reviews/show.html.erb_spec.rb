require 'rails_helper'

RSpec.describe "epa_reviews/show", type: :view do
  before(:each) do
    @epa_review = assign(:epa_review, EpaReview.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
