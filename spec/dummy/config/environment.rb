# Load the Rails application.
require_relative "application"

# Unfreeze arrays before Rails initialization
if defined?(ActiveSupport::Dependencies)
  ActiveSupport::Dependencies.autoload_paths = ActiveSupport::Dependencies.autoload_paths.dup if ActiveSupport::Dependencies.autoload_paths.frozen?
  ActiveSupport::Dependencies.autoload_once_paths = ActiveSupport::Dependencies.autoload_once_paths.dup if ActiveSupport::Dependencies.autoload_once_paths.frozen?
end

# Initialize the Rails application.
Rails.application.initialize!
