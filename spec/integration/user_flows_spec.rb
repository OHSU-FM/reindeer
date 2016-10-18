require "spec_helper"

feature "user flows test" do
  scenario "login and browse" do
    u = create :user, username: "t", password: "p", password_confirmation: "p"

    visit new_user_session_path
    expect(page).to have_content("Login")

    fill_in "Login",    with: u.username
    fill_in "Password", with: u.password
    click_button "Sign in"
    expect(page).to have_content("Log Out")

    visit ls_reports_path
    expect(page.status_code).to eq 200
  end
end
