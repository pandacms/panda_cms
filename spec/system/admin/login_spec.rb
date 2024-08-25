# require "rails_helper"

# RSpec.feature "User login", js: true do
#   google_user = OmniAuth.config.mock_auth[:google_oauth2][:info]
#   user_data = {
#     firstname: google_user[:first_name],
#     lastname: google_user[:last_name],
#     email: google_user[:email],
#     image_url: google_user[:image]
#   }

#   ## TODO:
#   ## James, not sure these are valid
#   ## Needs a fact table
#   ## There's a difference between create user account on first login,
#   ## create admin account on first login, and having the basic access
#   ## to login.
#   ## Also, what and how are permissions?

#   # context "when create admin account on first login is enabled", skip: true do
#   #   PandaCms.authentication[:google][:create_admin_account_on_first_login] = true

#   #   scenario "login with Google admin credentials" do
#   #     create(:admin_user, user_data)
#   #     visit "/admin"
#   #     click_button "Sign in with Google"
#   #     expect(page).to have_content("You are logged in!")
#   #     expect(page).to have_content("Dashboard")
#   #   end

#   #   scenario "prevent login with Google user credentials" do
#   #     create(:user, user_data)
#   #     visit "/admin"
#   #     click_button "Sign in with Google"
#   #     expect(page).to_not have_content("You are logged in!")
#   #     expect(page).to_not have_content("Dashboard")
#   #   end
#   # end

#   # context "when create admin account on first login is disabled", skip: true do
#   #   scenario "prevent login with Google admin credentials" do
#   #     PandaCms.authentication[:google][:create_admin_account_on_first_login] = false
#   #     create(:admin_user, user_data)
#   #     visit "/admin"
#   #     click_button "Sign in with Google"
#   #     expect(page).to_not have_content("You are logged in!")
#   #     expect(page).to_not have_content("Dashboard")
#   #   end

#   #   scenario "prevent login with Google user credentials" do
#   #     PandaCms.authentication[:google][:create_admin_account_on_first_login] = false
#   #     create(:user, user_data)
#   #     visit "/admin"
#   #     click_button "Sign in with Google"
#   #     expect(page).to_not have_content("You are logged in!")
#   #     expect(page).to_not have_content("Dashboard")
#   #   end
#   # end
# end
