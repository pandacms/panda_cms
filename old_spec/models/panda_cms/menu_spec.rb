require "rails_helper"

RSpec.describe PandaCms::Menu do
  let(:menu) { create(:menu, kind: "static") }
  let(:homepage) { create(:homepage) }
  let(:auto_menu) { create(:menu, kind: "auto", start_page: homepage) }

  describe "validations" do
    context "when kind is 'static'" do
      it "should have a unique name" do
        expect(menu).to validate_presence_of(:name)
        expect(menu).to validate_uniqueness_of(:name).case_insensitive
      end

      it "should have a valid kind" do
        expect(menu).to validate_presence_of(:kind)
        expect(menu).to validate_inclusion_of(:kind).in_array(["static", "auto"])
      end

      it "does not require a start page" do
        expect(menu).to_not validate_presence_of(:start_page)
      end
    end

    context "when kind is 'auto'" do
      it "should have a unique name" do
        expect(auto_menu).to validate_presence_of(:name)
        expect(auto_menu).to validate_uniqueness_of(:name).case_insensitive
      end

      it "should have a valid kind" do
        expect(auto_menu).to validate_presence_of(:kind)
        expect(auto_menu).to validate_inclusion_of(:kind).in_array(["static", "auto"])
      end

      it "requires a start page" do
        expect(auto_menu).to validate_presence_of(:start_page)
      end
    end
  end

  describe "associations" do
    it { should have_many(:menu_items).with_foreign_key(:panda_cms_menu_id).class_name("PandaCms::MenuItem").inverse_of(:menu) }
    it { should belong_to(:start_page).class_name("PandaCms::Page").with_foreign_key("start_page_id").inverse_of(:page_menu).optional }
    it { should accept_nested_attributes_for(:menu_items).allow_destroy(true) }
  end

  describe "methods" do
    describe "#generate_auto_menu_items" do
      it "creates a new menu item with the page title when a subpage is added" do
        # First, we just have the homepage
        expect(auto_menu.menu_items.count).to eq(1)
        expect(auto_menu.menu_items.first.text).to eq(homepage.title)
        # Saving the subpage automatically adds it to the menu
        subpage = build(:page, parent: homepage)
        subpage.save
        # Get the new menu items
        auto_menu.menu_items.reload
        menu_items = auto_menu.menu_items.order(:lft)
        expect(menu_items.count).to eq(2)
        expect(menu_items.first.text).to eq(homepage.title)
        expect(menu_items.last.text).to eq(subpage.title)
      end
    end

    describe "table name" do
      it { expect(described_class.table_name).to eq("panda_cms_menus") }
    end
  end
end
