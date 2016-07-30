require "spec_helper"

describe "user_assignment _deep_rows" do

  it "only shows comment icon if user_response has_comments?" do
    user = build :user
    c = create :cohort, :with_users, owner: user
    user.cohort = c
    user.save!
    ag = create :assignment_group, cohort: c
    ua = create :user_assignment
    ur = create :user_response, :with_comments, user_assignment: ua
    ur2 = create :user_response, user_assignment: ua
    sign_in user

    visit assignment_user_assignment_path(ua)
    expect(page).to have_link("", href: assignment_user_response_comments_path(ur))
    expect(page).not_to have_link("", href: assignment_user_response_comments_path(ur2))
  end
end
