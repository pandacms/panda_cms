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

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
