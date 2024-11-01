# First, load Cuprite Capybara integration
require "capybara/cuprite"

CUPRITE_LOGGER = Logger.new($stdout)

@cuprite_options = {
  window_size: [1440, 800],
  # See additional options for Dockerized environment in the respective section of this article
  browser_options: {},
  # Increase Chrome startup wait time (required for stable CI builds)
  process_timeout: 10,
  # Enable debugging capabilities
  inspector: true,
  # Slow down, if we need to
  slowmo: ENV["SLOWMO"]&.to_f,
  # Re-raise JS errors in Ruby
  js_errors: !ENV["JS_ERRORS"].in?(%w[n 0 no false]),
  # Allow running Chrome in a headful mode by setting HEADLESS env
  # var to a falsey value
  headless: !ENV["HEADLESS"].in?(%w[n 0 no false]),
  # Log cuprite logs to stdout
  logger: CUPRITE_LOGGER,
  # Make Docker happy
  "no-sandbox": nil
}

# Then, we need to register our driver to be able to use it later
# with #driven_by method.#
# NOTE: The name :cuprite is already registered by Rails.
# See https://github.com/rubycdp/cuprite/issues/180
Capybara.register_driver(:better_cuprite) do |app|
  driver = Capybara::Cuprite::Driver.new(
    app,
    **@cuprite_options
  )

  Rails.logger.info "Browser: #{driver.browser.process.browser_version}"
  Rails.logger.info "Protocol: #{driver.browser.process.protocol_version}"
  Rails.logger.info "V8: #{driver.browser.process.v8_version}"
  Rails.logger.info "Webkit: #{driver.browser.process.webkit_version}"

  driver
end

# Configure Capybara to use :better_cuprite driver by default
Capybara.default_driver = Capybara.javascript_driver = :better_cuprite

module CupriteHelpers
  # Drop #pause anywhere in a test to stop the execution.
  # Useful when you want to checkout the contents of a web page in the middle of a test
  # running in a headful mode.
  def pause
    page.driver.pause
  end

  # Drop #debug anywhere in a test to open a Chrome inspector and pause the execution
  # Usage: debug(binding)
  def debug(*)
    page.driver.debug(*)
  end

  # Allows sending a list of CSS selectors to be clicked on in the correct order (no delay)
  # Useful where you need to trigger e.g. a blur event on an input field
  def click_on_selectors(*css_selectors)
    css_selectors.each do |selector|
      page.driver.browser.at_css(selector).click
    end
  end
end

RSpec.configure do |config|
  config.include CupriteHelpers, type: :system
end
