require "dry-configurable"
require "importmap-rails"
require "lookbook"
require "omniauth"
require "omniauth/rails_csrf_protection"
require "omniauth/strategies/microsoft_graph"
require "omniauth/strategies/google_oauth2"
require "omniauth/strategies/github"
require "paper_trail"
require "view_component"

require "panda_cms/exceptions_app"

require "panda_cms/engine"
require "panda_cms/version"

module PandaCms
  extend Dry::Configurable

  setting :admin_path, default: "/admin"
  setting :authentication, default: {}
  setting :posts, default: {}
  setting :title, default: "Demo Site"
  setting :url, default: "http://localhost:3000"
  setting :require_login_to_view, default: false
  setting :error_reporting do
    setting :sentry do
      setting :enabled, default: false
      setting :dsn
    end
  end

  #
  # Defines the namespace for the admin routes
  #
  # @return [Symbol] The namespace for the admin routes
  # @visibility public
  # @example
  #  "/admin" => :admin
  def self.route_namespace
    PandaCms.config.admin_path.delete_prefix("/").to_sym
  end
end
