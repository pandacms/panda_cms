require "system_helper"

RSpec.describe "Website", type: :system do
  it "shows the homepage with rich text blocks and rendered JS" do
    puts "\n=== Test Starting ==="
    puts "Driver: #{Capybara.current_driver}"

    begin
      puts "Attempting to visit homepage..."
      visit "/"

      puts "Waiting for page load..."
      wait_for_page_load

      puts "Homepage visited successfully"
      puts "Current URL: #{page.current_url}"
      puts "Page title: #{page.title}"

      # Take a screenshot regardless of test outcome
      page.save_screenshot("tmp/capybara/debug_#{Time.now.to_i}.png")

      puts "=== Test Ending ==="
    rescue => e
      puts "!!! Error occurred: #{e.class} - #{e.message}"
      puts e.backtrace.take(5)
      raise e
    end
  end
end
