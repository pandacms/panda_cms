require "system_helper"

RSpec.describe "When editing a page", type: :system do
  context "when not logged in" do
    let(:homepage) { PandaCms::Page.find_by(path: "/") }

    it "returns a 404 error" do
      visit "/admin/pages/#{homepage.id}/edit"
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end

  context "when not logged in as an administrator" do
    let(:homepage) { PandaCms::Page.find_by(path: "/") }

    it "returns a 404 error" do
      login_as_user
      visit "/admin/pages/#{homepage.id}/edit"
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end

  context "when logged in as an administrator" do
    let(:about_page) { PandaCms::Page.find_by(path: "/about") }

    before(:each) do
      login_as_admin
      visit "/admin/pages/#{about_page.id}/edit"
    end

    it "shows the page details slideover" do
      within("main h1") do
        expect(page).to have_content("About")
      end

      expect(page).to have_content("Page Details")

      find("a", id: "slideover-toggle").click

      within("#slideover") do
        expect(page).to have_field("Title", with: "About")
        # expect(page).to have_field("Template", with: "Page", disabled: true)
      end
    end

    it "updates the page details" do
      find("a", id: "slideover-toggle").click
      within("#slideover") do
        fill_in "Title", with: "About Page 2"
        click_button "Save"
      end
      expect(page).to have_content("This page was successfully updated")
    end

    it "shows the correct link to the page" do
      expect(page).to have_link("/about", href: "/about")
    end

    it "allows clicking the link to the page" do
      pending "Not yet implemented"
      click_link "/about"
      expect(page).to have_current_path("/about")
    end

    it "shows the content of the page being edited" do
      within_frame "editablePageFrame" do
        expect(page).to have_content("About")
        expect(page).to have_content("Basic Page Layout")
      end
    end

    it "allows editing plain text content of the page" do
      pending "Not yet implemented"
      within_frame "editablePageFrame" do
        time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
        fill_in "[data-editable-kind='plain_text']:first", with: "New plain text content #{time}"
      end
      click_button "Save Changes"
      visit "/about"
      expect(page).to have_content "New plain text content #{time}"
    end

    it "allows editing rich text content of the page" do
      pending "Not yet implemented"
      within(".block[data-type='rich_text']") do
        find(".trix-editor").set("New rich text content")
        click_button "Save"
      end
      expect(page).to have_content("Block updated successfully")
    end

    it "allows editing code content of the page" do
      pending "Not yet implemented"
      within(".block[data-type='code']") do
        fill_in "Content", with: "# New code content"
        click_button "Save"
      end
      expect(page).to have_content("Block updated successfully")
    end
  end
end
