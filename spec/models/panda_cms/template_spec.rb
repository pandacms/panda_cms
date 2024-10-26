require "rails_helper"

RSpec.describe PandaCms::Template, type: :model do
  describe "associations" do
    it { should have_many(:pages).dependent(:restrict_with_error) }
    it { should have_many(:blocks).dependent(:restrict_with_error) }
    it { should have_many(:block_contents).through(:blocks) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:file_path) }
    it { should validate_uniqueness_of(:file_path) }

    context "file_path format" do
      it "allows valid layout paths where the file exists" do
        pending "WIP"
        template = build(:template, file_path: "layouts/page")
        expect(template).to be_valid
      end

      it "does not allow valid layout paths where the file does not exist" do
        template = build(:template, file_path: "layouts/page_not_here")
        expect(template).to be_invalid
      end

      it "rejects invalid layout paths" do
        template = build(:template, file_path: "invalid/path")
        expect(template).not_to be_valid
        expect(template.errors[:file_path]).to include("must be a valid layout file path")
      end
    end

    context "template file existence" do
      let(:template) { build(:template) }

      before do
        allow(File).to receive(:file?).and_return(false)
      end

      it "validates template file exists" do
        expect(template).not_to be_valid
        expect(template.errors[:file_path]).to include("must be an existing layout file path")
      end
    end
  end

  describe "scopes" do
    let!(:template1) { PandaCms::Template.find_by(file_path: "layouts/page") }
    let!(:template2) { PandaCms::Template.find_by(file_path: "layouts/homepage") }
    let!(:template3) { create(:template, max_uses: 3, pages_count: 3, file_path: "layouts/different_page") }

    describe ".available" do
      it "returns all templates with no max_uses or available capacity" do
        pending "WIP"
        available = described_class.available
        expect(available).to include(template1, template2)
        expect(available).not_to include(template3)
      end
    end
  end

  describe ".generate_missing_blocks" do
    pending "WIP"
    let(:template) { create(:template, file_path: "layouts/page") }
    let(:template_content) do
      <<~ERB
        <%= render PandaCms::RichTextComponent.new(key: :content) %>
        <%= render PandaCms::TextComponent.new(key: :sidebar) %>
        <%= render PandaCms::MenuComponent.new(key: :navigation) %>
      ERB
    end

    before do
      allow(Dir).to receive(:glob).and_return(["app/views/layouts/test.html.erb"])
      allow(File).to receive(:open).and_return(StringIO.new(template_content))
    end

    it "creates blocks for components in templates" do
      pending "WIP"
      expect {
        described_class.generate_missing_blocks
      }.to change(PandaCms::Block, :count).by(2) # Not counting MenuComponent
    end

    it "creates block_contents for existing pages" do
      pending "WIP"
      page = create(:page, template: template)
      described_class.generate_missing_blocks
      expect(page.block_contents.count).to eq(2)
    end
  end
end
