require "rails_helper"

RSpec.describe PandaCms::Template do
  let(:template) { build(:template) }

  describe "associations" do
    it { should have_many(:pages) }
    it { should have_many(:blocks) }
  end

  it "is valid with valid attributes" do
    template.name = "Page Template"
    template.file_path = "layouts/page"
    expect(template).to be_valid
  end

  it "is not valid without a name" do
    template.name = ""
    template.file_path = "layouts/page"
    expect(template).to_not be_valid
  end

  it "is not valid without a file path" do
    template.name = "Page 2 Template"
    template.file_path = ""
    expect(template).to_not be_valid
  end

  it "is not valid if the path does not exist" do
    template.name = "Non-Existent Template"
    template.file_path = "layouts/non_existent_template"
    expect(template).to_not be_valid
  end

  it "is not valid if the path is not a file that can be rendered" do
    template.name = "Non-Existent Template 2"
    template.file_path = "../../some_attack"
    expect(template).to_not be_valid
  end
end
