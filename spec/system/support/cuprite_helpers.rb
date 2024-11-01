# First, load Cuprite Capybara integration
require "capybara/cuprite"

# Options are:
# 1. StringIO.new logs _everything_. It's quite a lot.
# 2. CupriteLogger logs only Runtime.exceptionThrown and Log.entryAdded events.

# Source: https://github.com/rubycdp/cuprite/issues/113#issuecomment-753598305
class CupriteLogger
  attr_reader :logs

  def initialize
    @logs = []
  end

  # Filter out the noise - I believe Runtime.exceptionThrown and Log.entryAdded are the interesting log methods but there might be others you need
  def puts(log_str)
    _log_symbol, _log_time, log_body_str = log_str.strip.split(" ", 3)
    log_body = JSON.parse(log_body_str)
    if %w[Runtime.exceptionThrown Log.entryAdded].include?(log_body["method"])
      selenium_compatible_log_message = "#{log_body["params"]["entry"]["url"]} - #{log_body["params"]["entry"]["text"]}"
      @logs << {message: selenium_compatible_log_message, level: log_body["params"]["entry"]["level"]}
    end
  end

  def truncate
    @logs = []
  end
end

CUPRITE_LOGGER = CupriteLogger.new

@cuprite_options = {
  window_size: [1440, 800],
  # Have to set this to make CI happy
  browser_options: {
    "no-sandbox": nil
  },
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
  logger: CUPRITE_LOGGER
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

  process = driver.browser.process
  puts "Browser: #{process.browser_version}"
  puts "Protocol: #{process.protocol_version}"
  puts "V8: #{process.v8_version}"
  puts "Webkit: #{process.webkit_version}"

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

  config.around do |example|
    if ENV["CI"]
      CUPRITE_LOGGER.truncate(0)
      CUPRITE_LOGGER.rewind
    end

    example.run

    if ENV["CI"] && example.exception && example.metadata[:js]
      if example.exception.message.frozen?
        raise CUPRITE_LOGGER.string
      else
        example.exception.message << "\n\nDebug info:\n" + CUPRITE_LOGGER.string
      end
    end
  end
end
