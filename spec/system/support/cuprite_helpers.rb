# First, load Cuprite Capybara integration
require "capybara/cuprite"

@cuprite_options = {
  window_size: [1440, 800],
  browser_options: {
    "no-sandbox": nil,
    "disable-gpu": nil,
    "disable-dev-shm-usage": nil,
    "disable-background-networking": nil,
    "disable-default-apps": nil,
    "disable-extensions": nil,
    "disable-sync": nil,
    "disable-translate": nil,
    "disable-web-security": nil,
    "no-first-run": nil
  },
  process_timeout: 60,
  timeout: 30,
  inspector: ENV["DEBUG"] == "1",
  logger: StringIO.new,
  browser_logger: StringIO.new,
  slowmo: ENV.fetch("SLOWMO", 0.1).to_f,
  js_errors: true,
  headless: !ENV["HEADLESS"].in?(%w[n 0 no false]),
  pending_connection_errors: false  # Important: don't fail on pending connections
}

puts "Registering Cuprite with options: #{@cuprite_options.inspect}"

Capybara.register_driver(:better_cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, **@cuprite_options)
end

module CupriteHelpers
  def debug_info
    puts "\n=== Debug Info ==="
    puts "Current URL: #{begin
      page.current_url
    rescue
      "Error getting URL"
    end}"
    puts "Browser PID: #{begin
      page.driver.browser.process.pid
    rescue
      "Error getting PID"
    end}"
    puts "Browser Status: #{begin
      page.driver.browser.process.status
    rescue
      "Error getting status"
    end}"
    puts "Page HTML: #{begin
      page.html.truncate(500)
    rescue
      "Error getting HTML"
    end}"
    puts "=================="
  end

  def wait_for_page_load(timeout: 10)
    Timeout.timeout(timeout) do
      loop do
        break if page.evaluate_script("document.readyState") == "complete"
        sleep 0.1
      end
    end
  rescue Timeout::Error
    puts "Page load timeout after #{timeout} seconds"
  end
end

RSpec.configure do |config|
  config.include CupriteHelpers, type: :system

  config.before(:each, type: :system) do
    puts "Setting up system test..."
  end

  config.after(:each, type: :system) do
    puts "Cleaning up system test..."
    debug_info
    page.driver.quit
  end
end
