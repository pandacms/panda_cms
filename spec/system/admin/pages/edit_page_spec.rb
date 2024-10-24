require "system_helper"

RSpec.describe "When editing a page", type: :system do
  context "when not logged in" do
    let(:homepage) { PandaCms::Page.find_or_create_by(title: "Homepage", path: "/") }

    it "returns a 404 error" do
      visit "/admin/pages/#{homepage.id}/edit"
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end

  context "when not logged in as an administrator" do
    let(:homepage) { PandaCms::Page.find_or_create_by(title: "Homepage", path: "/") }

    it "returns a 404 error" do
      login_as_user
      visit "/admin/pages/#{homepage.id}/edit"
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end

  context "when logged in as an administrator" do
    let(:homepage) { PandaCms::Page.find_or_create_by(title: "Homepage", path: "/") }

    before(:each) do
      login_as_admin
      visit "/admin/pages/#{homepage.id}/edit"
    end

    it "shows the page details slideover" do
      within("#panda-cms-primary-content") do
        expect(page).to have_content("Homepage")
      end

      expect(page).to have_content("Page Details")
      find("a#slideover-toggle").click

      within("#slideover") do
        expect(page).to have_field("Title", with: "Homepage")
        expect(page).to have_field("Template", with: "Homepage Template")
      end
    end

    it "updates the page details"

    it "shows the correct link to the page"

    it "allows clicking the link to the page"

    it "shows the content of the page being edited"

    it "allows editing plain text content of the page"

    it "allows editing rich text content of the page"

    it "allows editing code content of the page"
  end
end
