# Usually, especially when using Selenium, developers tend to increase the max wait time.
# With Cuprite, there is no need for that.
# We use a Capybara default value here explicitly.
Capybara.default_max_wait_time = 2

# Normalize whitespaces when using `has_text?` and similar matchers,
# i.e., ignore newlines, trailing spaces, etc.
# That makes tests less dependent on slightly UI changes.
Capybara.default_normalize_ws = true

# Where to store system tests artifacts (e.g. screenshots, downloaded files, etc.).
# It could be useful to be able to configure this path from the outside (e.g., on CI).
Capybara.save_path = ENV.fetch("CAPYBARA_ARTIFACTS", "./tmp/capybara")

# See BetterRailsSystemTests#take_screenshot
Capybara.singleton_class.prepend(Module.new do
  attr_accessor :last_used_session

  def using_session(name, &block)
    self.last_used_session = name
    super
  ensure
    self.last_used_session = nil
  end
end)

PandaCms.config.url = "http://localhost:3000"
Capybara.app_host = "http://localhost:3000"
Capybara.server_host = "0.0.0.0"
Capybara.server_port = "3000"

# Capybara.server_host = "0.0.0.0" # bind to all interfaces
# Capybara.server = :puma, {Silent: true, Threads: "1:1"}
