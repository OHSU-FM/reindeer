require "rails_helper"

describe Comment do

  it "must have a factory" do
    expect(create :comment).to be_valid
  end

  it "belongs to a user" do
    expect(build :comment, user_id: nil).to be_invalid
  end

  it 'is polymorphic in assignment_group and user_response' do
    expect(create :comment, :assignment_comment).to be_valid
    expect(create :comment, :user_response_comment).to be_valid
  end

  it 'has a text body' do
    c = create :comment, body: "test"
    expect(c.body).to eql("test")
  end
end
