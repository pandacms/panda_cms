require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile
Bundler.require(*Rails.groups)
require "panda/cms"

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f

    # Handle frozen arrays if needed
    config.autoload_paths = config.autoload_paths.dup if config.autoload_paths.frozen?
    config.eager_load_paths = config.eager_load_paths.dup if config.eager_load_paths.frozen?

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Europe/London"
    # config.eager_load_paths << Rails.root.join("extras")

    config.active_support.to_time_preserves_timezone = :zone

    config.generators do |g|
      g.system_tests = nil
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end
  end
end
