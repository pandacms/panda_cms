require "rails_helper"

RSpec.describe "Pages" do
  context "when the page does not exist" do
    it "renders a 404 and error page" do
      get "/i_do_not_exist"
      expect(response).to have_http_status(:not_found)
    end
  end

  context "when the page exists" do
    it "renders the root page" do
      homepage = create(:homepage)
      get "/"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(homepage.title)
    end

    it "renders a normal page" do
      homepage = create(:homepage)
      sample_page = create(:page, path: "/sample", title: "Sample Page", parent: homepage)
      get "/sample"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(sample_page.title)
    end

    it "renders a subpage" do
      homepage = create(:homepage)
      sample_page = create(:page, path: "/sample", title: "Sample Page", parent: homepage)
      page = create(:page, path: "/sample/subpage", title: "Nested Subpage", parent: sample_page)
      get "/sample/subpage"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(page.title)
    end
  end

  context "when the page uses a different layout" do
    it "renders the correct template" do
      homepage = create(:homepage)
      different_page_template = create(:template, name: "Different Page", file_path: "layouts/different_page")
      page = create(:page, path: "/different-page", title: "Sample Page", template: different_page_template, parent: homepage)
      get "/different-page"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(page.title)
      expect(response.body).to include("Different Page Layout")
      expect(response.body).to_not include("Homepage Layout")
    end
  end

  context "when the page is already defined in the routes file" do
    it "does not allow the page URL to be used"
  end

  context "when the path is one of the Rails reserved paths" do
    it "does not allow the page to be used"
  end

  context "when the path is a file on the filesystem" do
    it "does not allow the page to be used"
  end
end
