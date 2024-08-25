require "bundler/setup"

APP_RAKEFILE = File.expand_path("spec/dummy/Rakefile", __dir__)
load "rails/tasks/engine.rake"
load "rails/tasks/statistics.rake"
load APP_RAKEFILE if File.exist?(APP_RAKEFILE)

require "bundler/gem_tasks"
