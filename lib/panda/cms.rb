require "panda"
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

require "panda/cms/exceptions_app"
require "panda/cms/engine"
require "panda/cms/version"

require "panda/cms/demo_site_generator"
require "panda/cms/editor_js"
require "panda/cms/editor_js_content"
require "panda/cms/editor_js/renderer"
require "panda/cms/editor_js/blocks/alert"
require "panda/cms/editor_js/blocks/header"
require "panda/cms/editor_js/blocks/image"
require "panda/cms/editor_js/blocks/list"
require "panda/cms/editor_js/blocks/paragraph"
require "panda/cms/editor_js/blocks/quote"
require "panda/cms/editor_js/blocks/table"
require "panda/cms/slug"

module Panda
  module CMS
    extend Dry::Configurable

    setting :title, default: "Demo Site"
    setting :admin_path, default: "/admin"
    setting :require_login_to_view, default: false
    setting :authentication, default: {}
    setting :posts, default: {enabled: true, prefix: "blog"}
    setting :route_namespace, default: "/admin"
    setting :url

    def self.root_path
      config.admin_path
    end

    class << self
      def route_namespace
        config.admin_path
      end

      def configure
        yield config if block_given?
      end
    end
  end
end
