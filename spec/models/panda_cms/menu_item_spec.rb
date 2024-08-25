require "rails_helper"

RSpec.describe PandaCms::MenuItem do
  let(:menu) { create(:menu) }
  let(:menu_item) { create(:menu_item, menu: menu) }

  describe "associations" do
    it "should always belong to a menu and optionally belong to a page" do
      expect(menu_item).to belong_to(:menu)
      expect(menu_item).to belong_to(:page).optional
    end
  end

  describe "validations" do
    it "should have unique link text within the scope of the menu" do
      expect(menu_item).to validate_uniqueness_of(:text).scoped_to(:panda_cms_menu_id).case_insensitive
    end

    it "should require the link text" do
      expect(menu_item).to validate_presence_of(:text)
    end

    it "is not valid without a page OR an external_url" do
      menu_item.page = nil
      menu_item.external_url = nil
      expect(menu_item).to_not be_valid
    end

    it "is not valid with a page AND an external_url" do
      menu_item.page = create(:page)
      menu_item.external_url = "http://www.google.com"
      expect(menu_item).to_not be_valid
    end

    it "is valid with a page but no external_url" do
      menu_item.page = create(:page)
      menu_item.external_url = nil
      expect(menu_item).to be_valid
    end

    it "is valid with an external_url but no page" do
      menu_item.page = nil
      menu_item.external_url = "http://www.google.com"
      expect(menu_item).to be_valid
    end
  end
end
