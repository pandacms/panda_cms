require "system_helper"

RSpec.describe "Website" do
  before(:each) do
    create_homepage
    visit "/"
  end

  it "shows the homepage" do
    # TODO: Look at Percy.io for visual regression testing
    expect(page).to have_content("Homepage Layout")
    # Simple JS
    expect(page).to have_content("I like ice cream!")
    # Stimulus JS
    expect(page).to have_content("Hello, Stimulus!")
  end

  # it "temporarily tests admin JS"
end

def create_homepage
  homepage_template = PandaCms::Template.find_or_create_by!(
    name: "Homepage",
    file_path: "layouts/homepage",
    max_uses: 1
  )

  homepage = PandaCms::Page.find_or_create_by!(
    path: "/",
    title: "Home",
    template: homepage_template
  )

  [
    {kind: "rich_text", name: "Introduction Text", key: "introduction_text", template: homepage_template},
    {kind: "rich_text", name: "Main Content", key: "main_content", template: homepage_template}
  ].each do |block_data|
    PandaCms::BlockContent.find_or_create_by!(
      page: homepage,
      block: PandaCms::Block.find_or_create_by!(block_data),
      content: "Here is some #{block_data[:name].downcase} content."
    )
  end
end
