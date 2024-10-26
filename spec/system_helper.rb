# Load general RSpec Rails configuration
require "rails_helper"

# Load seed data (from DemoSiteGenerator) before loading system tests
RSpec.configure do |config|
  config.before(:suite) do
    Rails.application.load_seed
  end
end

# Load configuration files and helpers
Dir[File.join(__dir__, "system/support/**/*.rb")].sort.each { |file| require file }
