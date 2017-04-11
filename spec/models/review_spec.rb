require 'rails_helper'

RSpec.describe Review, type: :model do
  it "has a factory" do
    expect( build :review ).to be_valid
  end

  it "belongs_to a user" do
    expect((create :review).user).to be_a(User)
  end

  describe "validates" do
    it "presence of a user" do
      expect(build :review, user: nil).not_to be_valid
    end
  end

  describe "sources" do
    let(:review) { create :review }
    let(:ra_source) { create :source, :role_aggregate, review: review }

    before :each do
      # make/load objects
      ra_source
      review.reload
    end

    it "#role_aggregates should be a list of role_aggregates" do
      expect(review.role_aggregates.first).to be_a RoleAggregate
    end
  end
end
