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

    it "presence of a user_type" do
      expect(build :review, user_type: nil).not_to be_valid
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

  describe "user_type enum" do
    it "holds user_type as enum" do
      r = create :review
      expect(r.md?).to be_truthy
    end

    it "has three possible user_types" do
      expect(Review.user_types.count).to eq 3
    end

    it "can collect instances based on user_type val" do
      r1 = create :review, user_type: "icuapp"
      r2 = create :review, user_type: "md"
      expect(Review.md.count).to eq 1
      expect(Review.md.first).to eq r2
    end
  end
end
