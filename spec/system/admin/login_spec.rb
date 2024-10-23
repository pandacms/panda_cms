require "system_helper"

RSpec.feature "User login", type: :system do
  context "when logging in as an admin" do
    it "logs in with Google credentials" do
      google_user_data = Faker::Omniauth.google
      omniauth_mock_user = OmniAuth::AuthHash.new(google_user_data)

      OmniAuth.config.mock_auth[:google] = omniauth_mock_user

      google_admin_user = PandaCms::User.create!(
        firstname: google_user_data[:info][:first_name],
        lastname: google_user_data[:info][:last_name],
        email: google_user_data[:info][:email],
        image_url: "/panda-cms-assets/panda-nav.png",
        admin: true
      )

      Rails.application.env_config["omniauth.auth"] = omniauth_mock_user

      visit "/admin"
      find("#button-sign-in-google").click

      expect(page).to have_content("You are logged in!")
      expect(page).to have_content("Dashboard")

      visit "/admin/pages"
    end
  end
end
