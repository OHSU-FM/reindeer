require "spec_helper"

describe "assignment_group#show" do

  it "shows an index of owner comments" do
    user = create :coach
    ag = create :assignment_group, :with_users, owner: user
    comment = create :comment, user: user, commentable: ag
    sign_in user
    visit assignment_assignment_groups_path
    expect(page).to have_content comment.body
  end
end
