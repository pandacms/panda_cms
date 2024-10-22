# Capybara.register_driver :headless_chrome do |app|
#   options = ::Selenium::WebDriver::Chrome::Options.new
#   options.add_argument("--headless")
#   options.add_argument("--no-sandbox")
#   options.add_argument("--disable-gpu")
#   options.add_argument("--disable-dev-shm-usage")
#   options.add_argument("--window-size=1400,1400")

#   Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
# end

# Capybara.register_driver :chrome do |app|
#   options = ::Selenium::WebDriver::Chrome::Options.new
#   options.add_argument("--disable-dev-shm-usage")
#   options.add_argument("--window-size=1400,1400")

#   Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
# end

# Capybara.javascript_driver = if ENV.fetch("IS_CI", false)
#   :headless_chrome
# else
#   :chrome
# end

# Capybara.configure do |config|
#   config.always_include_port = true
#   # config.server = :puma, {Silent: true}
#   # config.default_driver = :headless_chrome
# end

#### TODO: What about lib/panda_cms/slug_spec.rb?

# def base_url
#   Capybara.app_host + ":" + Capybara.current_session.server.port.to_s
# end

def pause
  $stderr.write "Press enter to continue"
  $stdin.gets
end
