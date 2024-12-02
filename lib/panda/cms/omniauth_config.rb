module Panda
  module CMS
    class OmniauthConfig
      def self.configure(app)
        OmniAuth.config.logger = Rails.logger

        # Get the configured auth path
        auth_path = "#{Panda::CMS.config.admin_path}/auth"
        callback_path = "/callback"

        available_providers.each do |provider, options|
          if Panda::CMS.config.authentication.dig(provider, :enabled)
            auth_path = auth_path.starts_with?("/") ? auth_path : "/#{auth_path}"
            options[:defaults][:path_prefix] = auth_path

            options[:defaults][:redirect_uri] = if Rails.env.test?
              "#{Capybara.app_host}#{auth_path}/#{provider}#{callback_path}"
            else
              "#{Panda::CMS.config.url}#{auth_path}/#{provider}#{callback_path}"
            end

            provider_config = options[:defaults].merge(Panda::CMS.config.authentication[provider])

            app.config.middleware.use OmniAuth::Builder do
              provider options[:strategy], provider_config
            end
          end
        end
      end

      def self.available_providers
        {
          microsoft: {
            strategy: :microsoft_graph,
            defaults: {
              name: "microsoft",
              client_id: Rails.application.credentials.dig(:microsoft, :client_id),
              client_secret: Rails.application.credentials.dig(:microsoft, :client_secret),
              skip_domain_verification: false,
              client_options: {
                site: "https://login.microsoftonline.com/",
                token_url: "common/oauth2/v2.0/token",
                authorize_url: "common/oauth2/v2.0/authorize"
              },
              create_account_on_first_login: false,
              create_admin_account_on_first_login: false,
              hidden: false
            }
          },
          google: {
            strategy: :google_oauth2,
            defaults: {
              name: "google",
              client_id: Rails.application.credentials.dig(:google, :client_id),
              client_secret: Rails.application.credentials.dig(:google, :client_secret),
              create_account_on_first_login: false,
              create_admin_account_on_first_login: false,
              scope: "email, profile",
              image_aspect_ratio: "square",
              image_size: 150,
              prompt: "select_account",
              hidden: false
            }
          },
          github: {
            strategy: :github,
            defaults: {
              name: "github",
              client_id: Rails.application.credentials.dig(:github, :client_id),
              client_secret: Rails.application.credentials.dig(:github, :client_secret),
              scope: "user:email,read:user",
              create_account_on_first_login: false,
              create_admin_account_on_first_login: false,
              hidden: false
            }
          }
        }
      end
    end
  end
end
