# First, load Cuprite Capybara integration
require "capybara/cuprite"

# Options are:
# 1. StringIO.new logs _everything_. It's quite a lot.
# 2. FerrumLogger logs only Runtime.exceptionThrown and Log.entryAdded events.

# Source: https://github.com/rubycdp/cuprite/issues/113

class FerrumLogger
  attr_accessor :page

  COLORS = {
    "error" => :red,
    "warn" => :yellow
  }

  def puts(log_str)
    _log_symbol, _log_time, log_body_str = log_str.strip.split(" ", 3)

    return if log_body_str.nil?

    log_body = JSON.parse(log_body_str)

    return unless log_body["method"] === "Runtime.consoleAPICalled"

    Thread.new do
      type = log_body.dig "params", "type"
      args = log_body.dig "params", "args"

      args.each do |arg|
        json = to_json(arg)

        Rails.logger.debug TTY::Box.frame((json.is_a?(Array) || json.is_a?(Hash)) ? JSON.pretty_generate(json) : json, padding: 1, title: {top_left: "console.#{type}"}, style: {border: {fg: COLORS[type]}}, width: TTY::Screen.width)
      end
    end
  end

  protected

  def to_json(remote_object)
    type, object_id, value = remote_object.values_at "type", "objectId", "value"

    if type === "object" && value
      value.reduce({}) do |object, (key, value)|
        object.merge(key => to_json(value))
      end
    elsif type === "array" && value
      value.map do |array_value|
        to_json(array_value)
      end
    elsif object_id
      page.command(
        "Runtime.callFunctionOn",
        functionDeclaration: "function test() { return this }",
        objectId: object_id,
        serializationOptions: {serialization: "deep"}
      ).dig("result", "deepSerializedValue", "value").reduce({}) do |object, (key, value)|
        object.merge(key => to_json(value))
      end
    else
      value
    end
  rescue Ferrum::NoExecutionContextError => e
    e.message
  end
end

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
  logger: FerrumLogger.new
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
  config.before(:each, type: :system) do
    page.driver.browser.options.logger.page = page.driver.browser.page
  end
end
