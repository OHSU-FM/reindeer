require "spec_helper"

describe CommentThread do
  it "must have a factory" do
    expect(build :comment_thread).to be_valid
  end

  it "must have a threadable" do
    expect(build :comment_thread, threadable: nil).to be_invalid
  end

  it "must have a first_user" do
    expect(build :comment_thread, first_user: nil).to be_invalid
  end

  it "must have a second_user" do
    expect(build :comment_thread, second_user: nil).to be_invalid
  end

  describe "methods:" do
    it "#has_comments? returns true if there are comments on the thread" do
      ct = create :comment_thread
      expect(ct.has_comments?).to be_falsey
      c = create :comment, commentable: ct
      expect(ct.has_comments?).to be_truthy
    end
  end
end
