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

  scenario "request a page with no session" do
    u = create :user, username: "t", password: "p", password_confirmation: "p"

    visit root_path
    expect(page).to have_content("Login")
  end

  scenario "redirect to requested path after relogin when session timeout" do
    u = create :user, :with_dashboard, username: "t", password: "p", password_confirmation: "p"

    visit ls_reports_path
    fill_in "Login",    with: u.username
    fill_in "Password", with: u.password
    click_button "Sign in"
    expect(page.current_path).to eq "/ls_reports"
  end
end
