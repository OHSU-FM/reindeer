require "rails_helper"

describe Comment do

  it "must have a factory" do
    create :comment, :with_defaults
  end
end
