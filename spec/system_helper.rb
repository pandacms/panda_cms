# Load general RSpec Rails configuration
require "rails_helper"

# Load configuration files and helpers
Dir[File.join(__dir__, "system/support/**/*.rb")].sort.each { |file| require file }

RSpec.configure do |config|
  config.include PandaCms::SessionHelpers, type: :system
end

# Set OmniAuth test mode and providers
OmniAuth.config.test_mode = true
