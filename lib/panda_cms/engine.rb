require "importmap-rails"
require "turbo-rails"
require "stimulus-rails"

module PandaCms
  class Engine < ::Rails::Engine
    isolate_namespace PandaCms
    engine_name "panda_cms"

    initializer "panda_cms" do |app|
    end

    config.to_prepare do
      ApplicationController.helper(::ApplicationHelper)
    end

    # Set our generators
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_bot, dir: "spec/factories"
      g.view_specs false
      g.templates.unshift File.expand_path("../../templates", __FILE__)
    end

    # Make files in public available to the main app (e.g. /panda-cms-assets/favicon.ico)
    config.app_middleware.use(
      Rack::Static,
      urls: ["/panda-cms-assets"],
      root: PandaCms::Engine.root.join("public")
    )

    # Custom error handling
    config.exceptions_app = PandaCms::ExceptionsApp.new(exceptions_app: routes)

    # Add importmap paths from the engine
    initializer "panda_cms.importmap", before: "importmap" do |app|
      app.config.importmap.paths << root.join("config/importmap.rb")
      app.config.importmap.cache_sweepers << root.join("app/javascript")
    end

    config.after_initialize do |app|
      # Append routes to the routes file
      app.routes.append do
        mount PandaCms::Engine => "/", :as => "panda_cms"
        post "/_forms/:id", to: "panda_cms/form_submissions#create", as: :panda_cms_form_submit
        get "/_maintenance", to: "panda_cms/errors#error_503", as: :panda_cms_maintenance
        get "/*path", to: "panda_cms/pages#show", as: :panda_cms_page
        root to: "panda_cms/pages#root"
      end
    end

    # Add the migrations to the main app
    initializer "panda_cms.migrations" do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    # Set up ViewComponent and Lookbook
    # config.view_component.component_parent_class = "PandaCms::BaseComponent"
    config.view_component.view_component_path = PandaCms::Engine.root.join("lib/components").to_s
    config.eager_load_paths << PandaCms::Engine.root.join("lib/components").to_s
    config.view_component.generate.sidecar = true
    config.view_component.generate.preview = true
    config.view_component.preview_paths ||= []
    config.view_component.preview_paths << PandaCms::Engine.root.join("lib/component_previews").to_s
    config.view_component.generate.preview_path = "lib/component_previews"

    # Set up authentication
    initializer "panda_cms.omniauth", before: "omniauth" do |app|
      app.config.session_store :cookie_store, key: "_panda_cms_session"
      app.config.middleware.use ActionDispatch::Cookies
      app.config.middleware.use ActionDispatch::Session::CookieStore, app.config.session_options

      OmniAuth.config.logger = Rails.logger
      auth_path = "#{PandaCms.route_namespace}/auth"
      callback_path = "/callback"

      # TODO: Move this to somewhere more sensible
      # Define the mapping of our provider "names" to the OmniAuth strategies and configuration
      available_providers = {
        microsoft: {
          strategy: :microsoft_graph,
          defaults: {
            name: "microsoft",
            # Setup at the following URL:
            # https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationsListBlade
            client_id: Rails.application.credentials.dig(:microsoft, :client_id),
            client_secret: Rails.application.credentials.dig(:microsoft, :client_secret),
            # Don't change this or the sky will fall on your head
            # https://github.com/synth/omniauth-microsoft_graph/tree/main?tab=readme-ov-file#domain-verification
            skip_domain_verification: false,
            # If your application is single-tenanted, replace "common" with your tenant (directory) ID
            # from https://portal.azure.com/#settings/directory, otherwise you'll likely want to leave
            # these settings unchanged
            client_options: {
              site: "https://login.microsoftonline.com/",
              token_url: "common/oauth2/v2.0/token",
              authorize_url: "common/oauth2/v2.0/authorize"
            },
            # If you assign specific users or groups, you will likely want to set this to
            # true to enable auto-provisioning
            create_account_on_first_login: false,
            create_admin_account_on_first_login: false,
            # Don't hide this provider from the login page
            hidden: false
          }
        },
        google: {
          strategy: :google_oauth2,
          defaults: {
            name: "google",
            # Setup at the following URL: https://console.developers.google.com/
            client_id: Rails.application.credentials.dig(:google, :client_id),
            client_secret: Rails.application.credentials.dig(:google, :client_secret),
            # If you assign specific users or groups, you will likely want to set this to
            # true to enable auto-provisioning
            create_account_on_first_login: false,
            create_admin_account_on_first_login: false,
            # Options we need
            scope: "email, profile",
            image_aspect_ratio: "square",
            image_size: 150,
            # Worth setting select_account as default, as many people have multiple Google accounts now:
            prompt: "select_account",
            # You should probably also set the 'hd' option, huh?,
            # Don't hide this provider from the login page
            hidden: false
          }
        },
        github: {
          strategy: :github,
          defaults: {
            name: "github",
            # Setup at the following URL: https://github.com/settings/applications/new
            # with a callback of
            # In the meantime, as long as you're set to /admin as your login path, and on
            # http://localhost:3000, you can use these for a first login :)
            client_id: Rails.application.credentials.dig(:github, :client_id),
            client_secret: Rails.application.credentials.dig(:github, :client_secret),
            scope: "user:email,read:user",
            create_account_on_first_login: false,
            create_admin_account_on_first_login: false,
            # Don't hide this provider from the login page
            hidden: false
          }
        }
      }

      available_providers.each do |provider, options|
        if PandaCms.config.authentication.dig(provider, :enabled)
          auth_path = auth_path.starts_with?("/") ? auth_path : "/#{auth_path}"
          options[:defaults][:path_prefix] = auth_path
          options[:defaults][:redirect_uri] = "#{PandaCms.config.url}#{auth_path}/#{provider}#{callback_path}"

          provider_config = options[:defaults].merge(PandaCms.config.authentication[provider])

          Rails.logger.info("Configuring OmniAuth for #{provider} with #{provider_config}")

          app.config.middleware.use OmniAuth::Builder do
            provider options[:strategy], provider_config
          end
        end
      end
    end
  end
end
