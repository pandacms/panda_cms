module Panda
  module CMS
    class Railtie < Rails::Railtie
      config.before_initialize do |app|
        # Set up OmniAuth base configuration
        OmniAuth.config.logger = Rails.logger

        # Configure available providers
        if Panda::CMS.config.authentication.present?
          Panda::CMS::OmniauthConfig.available_providers.each do |provider, options|
            if Panda::CMS.config.authentication.dig(provider, :enabled)
              auth_path = "#{Panda::CMS.config.admin_path}/auth"
              auth_path = auth_path.starts_with?("/") ? auth_path : "/#{auth_path}"
              callback_path = "/callback"

              options[:defaults][:path_prefix] = auth_path
              options[:defaults][:redirect_uri] = if Rails.env.test?
                "#{Capybara.app_host}#{auth_path}/#{provider}#{callback_path}"
              else
                "#{Panda::CMS.config.url}#{auth_path}/#{provider}#{callback_path}"
              end

              provider_config = options[:defaults].merge(Panda::CMS.config.authentication[provider])

              # Add to middleware configuration instead of directly to stack
              app.config.middleware.use OmniAuth::Builder do
                provider options[:strategy], provider_config
              end
            end
          end
        end
      end
    end
  end
end
