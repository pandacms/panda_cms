require "rails_helper"

RSpec.describe "Edit a page", js: true do
  scenario "when the user is not logged in it returns a 404 error" do
    homepage = create(:homepage, title: "Home Page")
    visit "/admin/pages/#{homepage.id}/edit"
    expect(page).to have_content("The page you were looking for doesn't exist.")
  end

  scenario "when the user is logged in as a user (not admin) it returns a 404 error", js: true do
    homepage = create(:homepage, title: "Home Page")
    create_and_login_user_with(:github)
    visit "/admin/pages/#{homepage.id}/edit"
    expect(page).to have_content("The page you were looking for doesn't exist.")
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
