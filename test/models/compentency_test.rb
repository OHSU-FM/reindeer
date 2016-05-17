require "test_helper"

describe Compentency do
  let(:compentency) { Compentency.new }

  it "must be valid" do
    value(compentency).must_be :valid?
  end
end
