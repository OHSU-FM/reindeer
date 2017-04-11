require 'rails_helper'

RSpec.describe Source, type: :model do
  it "has a factory" do
    expect( build :source, :role_aggregate ).to be_valid
  end

  it "belongs to a review" do
    r = create :review
    expect((create :source, :role_aggregate, review: r).review).to eq r
  end

  describe "validates" do
    it "presence of sourceable" do
      expect(build :source, sourceable: nil).not_to be_valid
    end
  end
end
