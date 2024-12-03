require "system_helper"

RSpec.describe "Website" do
  include_context "with standard pages"
  it "shows the homepage with rich text blocks and rendered JS" do
    visit "/"
    # TODO: Look at Percy.io for visual regression testing
    expect(page).to have_content("Homepage Layout")
    # Simple JS
    expect(page).to have_content("I like ice cream!")
    # Stimulus JS
    expect(page).to have_content("Hello, Stimulus!")
  end

  it "shows the about page with plain text, code and rich text blocks" do
    visit "/about"

    # Debug output for troubleshooting
    if ENV["DEBUG"]
      about = Panda::CMS::Page.find_by(path: "/about")
      puts "\nPage: #{about.attributes.inspect}"
      puts "\nBlock Contents:"
      about.block_contents.each do |bc|
        puts "\nBlock: #{bc.block.name}"
        puts "Raw Content: #{bc.content.inspect}"
        puts "Rendered Content: #{bc.cached_content.inspect}"
      end
    end

    # Test what the user sees
    expect(page).to have_content("This is the main content of the about page")
    expect(page).to have_content("Here is some HTML code")
    expect(page).to have_content("Here is some plain text content")

    # Test that HTML is rendered correctly
    expect(page).to have_css("p strong", text: "Here is some HTML code")
    expect(page).to have_css("p", text: "This is the main content of the about page")
  end
end
