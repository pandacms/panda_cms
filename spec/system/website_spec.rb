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
    expect(page).to have_content("Here is some plain text content.")
    expect(page).to have_content("Here is some HTML code.")
    expect(page).to have_content("This is the main content of the about page.")
  end
end
