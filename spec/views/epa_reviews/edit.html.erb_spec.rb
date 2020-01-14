require 'rails_helper'

RSpec.describe "epa_reviews/edit", type: :view do
  before(:each) do
    @epa_review = assign(:epa_review, EpaReview.create!())
  end

  it "renders the edit epa_review form" do
    render

    assert_select "form[action=?][method=?]", epa_review_path(@epa_review), "post" do
    end
  end
end
