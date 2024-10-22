require "rails_helper"

RSpec.describe PandaCms::Page do
  let(:homepage) { build_stubbed(:homepage) }
  let(:page) { build_stubbed(:page) }

  describe "associations" do
    it { should belong_to(:template) }
    it { should have_many(:blocks).through(:template) }
    it { should have_many(:block_contents).with_foreign_key(:panda_cms_page_id) }
    it { should have_many(:menu_items).with_foreign_key(:panda_cms_page_id) }
  end

  describe "page factory" do
    it "creates a valid factory" do
      expect(page).to be_valid
    end
  end

  describe "homepage factory" do
    it "creates a valid factory" do
      expect(homepage).to be_valid
    end
  end

  it "is not valid without a title" do
    page.title = nil
    expect(page).to_not be_valid
  end

  it "is not valid without a path" do
    page.path = nil
    expect(page).to_not be_valid
  end

  it "is not valid if the path does not start a with a /" do
    page.path = "sample"
    expect(page).to_not be_valid
  end

  it "is not valid without a parent unless it is the homepage" do
    expect(homepage.path).to eq("/")
    expect(homepage.parent).to eq(nil)
    expect(homepage).to be_valid

    page.path = "/subpage"
    page.parent = nil
    expect(page).to_not be_valid

    page.path = "/subpage"
    page.parent = homepage
    expect(page).to be_valid
  end
end
