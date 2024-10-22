require "rails_helper"

RSpec.describe PandaCms::BlockContent do
  let(:block_content) { create(:block_content) }

  describe "factory" do
    it "should create a valid factory" do
      expect(block_content).to be_valid
    end
  end

  describe "validations" do
    it { should validate_presence_of(:block) }

    it "should validate uniqueness of block scoped to page"
  end

  describe "associations" do
    it { should belong_to(:page).optional.touch(true) }
    it { should belong_to(:block).required }
    it { should have_many(:versions).class_name("PandaCms::BlockContentVersion") }
  end

  describe "table name" do
    it { expect(PandaCms::BlockContent.table_name).to eq("panda_cms_block_contents") }
  end
end
