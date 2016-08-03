require "spec_helper"

describe "assignment_group#show" do

  it "shows a list of assignment_groups the user owns" do
    user = build :user
    c = create :cohort, :with_users, owner: user
    user.cohort = c
    user.save!
    ag = create :assignment_group, cohort: c
    ag2 = create :assignment_group, cohort: c
    sign_in user

    visit assignment_assignment_groups_path
    expect(page).to have_content ag.title
    expect(page).to have_content ag2.title
  end

  it "shows an index of owner comments" do
    user = create :user
    c = create :cohort, :with_users, owner: user
    ag = create :assignment_group, cohort: c
    comment = create :comment, user: user, commentable: ag
    sign_in user

    visit assignment_assignment_groups_path ag
    expect(page).to have_content comment.body
  end

  it "shows a list of users in the assignment_group if authorized" do
    user = create :coach
    c = create :cohort, owner: user
    ag = create :assignment_group, cohort: (create :cohort, :with_users)
    comment = create :comment, user: user, commentable: ag
    sign_in user

    visit assignment_assignment_groups_path
    list = User.find(ag.user_ids.map {|id| id.to_i }).map {|u| u.username }
    list.each do |u|
      expect(page).to have_content u
    end
  end
end
