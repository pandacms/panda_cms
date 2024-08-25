require "rails_helper"

RSpec.describe "Edit a page", js: true do
  scenario "when the user is not logged in it returns a 404 error" do
    homepage = create(:homepage, title: "Home Page")
    visit "/admin/pages/#{homepage.id}/edit"
    expect(page).to have_content("The page you were looking for could not be found. Sad panda.")
  end

  scenario "when the user is logged in as a user it returns a 404 error", js: true do
    homepage = create(:homepage, title: "Home Page")
    create_and_login_user_with(:github)
    visit "/admin/pages/#{homepage.id}/edit"
    expect(page).to have_content("The page you were looking for could not be found. Sad panda.")
  end
  # todo: permissions here?

  scenario "when the user is logged in as an admin" do
    homepage = create(:homepage, title: "Home Page 3")
    create_and_login_user_with(:github, admin: true)
    visit "/admin/pages/#{homepage.id}/edit"

    within("#panda-cms-primary-content") do
      expect(page).to have_content("Home Page 3")
    end

    expect(page).to have_content("Page Details")
    find("a#slideover-toggle").click

    within("#slideover") do
      expect(page).to have_field("Title", with: "Home Page 3")
      expect(page).to have_field("Template", with: "Homepage Template")
    end
  end
end

def create_user_with(provider, admin: false)
  info = OmniAuth.config.mock_auth[provider][:info]
  name_parts = info[:name].split(" ")

  PandaCms::Current.user = PandaCms::User.create!(
    admin: admin,
    email: info[:email],
    firstname: name_parts.first,
    lastname: name_parts.last,
    image_url: info[:image]
  )
end

def create_and_login_user_with(provider, admin: false)
  user = create_user_with(provider, admin: admin)
  login_as(user, provider: provider)
end

def login_as(user, provider: :github)
  Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[provider]
  visit "/admin"

  cookies = ActionDispatch::TestRequest.create.cookie_jar
  cookies.signed[:session_id] = {value: user.id, httpOnly: true, sameSite: :Lax}

  # For Selenium:
  page.driver.browser.manage.add_cookie(
    name: "session_id",
    value: cookies[:session_id],
    sameSite: :Lax,
    httpOnly: true
  )

  # For Capybara:
  # browser = Capybara.current_session.driver.browser
  # browser.manage.add_cookie :name => 'ab', :value => 'true', :expires => Time.now + 3600
  # page.driver.browser.manage.add_cookie(name: "session_id", value: cookie_jar[:session_id], sameSite: :Lax, httpOnly: true)
  # visit "/admin"

  find("#button-sign-in-#{provider}").click
end

def base_url
  Capybara.app_host + ":" + Capybara.current_session.server.port.to_s
end
