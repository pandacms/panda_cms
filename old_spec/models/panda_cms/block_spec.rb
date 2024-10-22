require "rails_helper"

RSpec.describe PandaCms::Block do
  let(:block) { create(:block) }

  describe "factory" do
    it "should create a valid factory" do
      expect(block).to be_valid
    end
  end

  describe "validations" do
    it { should validate_presence_of(:kind) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:key) }

    it "should validate uniqueness of key scoped to template" do
      expect(block).to validate_uniqueness_of(:key).scoped_to(:panda_cms_template_id).case_insensitive
    end
  end

  describe "associations" do
    it { should belong_to(:template).class_name("PandaCms::Template").with_foreign_key(:panda_cms_template_id).optional }
    it { should have_many(:block_contents).class_name("PandaCms::BlockContent").with_foreign_key(:panda_cms_block_id).inverse_of(:block) }
  end

  describe "enums" do
    it {
      should define_enum_for(:kind)
        .with_values({
          plain_text: "plain_text",
          rich_text: "rich_text",
          iframe: "iframe",
          list: "list"
        })
        .backed_by_column_of_type(:enum)
    }
  end

  describe "table name" do
    it { expect(PandaCms::Block.table_name).to eq("panda_cms_blocks") }
  end
end
