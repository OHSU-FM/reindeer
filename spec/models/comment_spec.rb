require "rails_helper"

describe Comment do

  it "must have a factory" do
    expect(create :comment).to be_valid
  end

  it "belongs to a user" do
    expect(build :comment, user_id: nil).to be_invalid
  end

  it "must have body content" do
    # no blank comments
    expect(build :comment, body: nil).to be_invalid
  end

  it "is polymorphic in assignment_group and user_response" do
    expect(create :comment, :assignment_comment).to be_valid
    expect(create :comment, :user_response_comment).to be_valid
  end

  it "has a text body" do
    c = create :comment, body: "test"
    expect(c.body).to eql("test")
  end

  describe "methods" do
    it "#row_partial_path" do
      c = build :comment
      flagged_c = create :comment, flagged_as: "test"
      expect(c.row_partial_path).to eq "comment_row"
      expect(flagged_c.row_partial_path).to eq "test_comment_row"
    end
  end
end
