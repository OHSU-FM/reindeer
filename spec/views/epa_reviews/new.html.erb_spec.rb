require 'rails_helper'

RSpec.describe "epa_reviews/new", type: :view do
  before(:each) do
    assign(:epa_review, EpaReview.new())
  end

  it "renders new epa_review form" do
    render

    assert_select "form[action=?][method=?]", epa_reviews_path, "post" do
    end
  end
end
