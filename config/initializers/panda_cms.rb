PandaCms.configure do |config|
  # The main title of your website
  # The default is "Demo Site"
  config.title = "Demo Site"
  # The path to the administration panel, which must start with a /
  # The default is "/admin"
  config.admin_path = "/admin"
  # Is login required to access the site? (Else, show maintenance page)
  config.require_login_to_view = false
  # Authentication providers
  config.authentication = {
    microsoft: {
      enabled: true,
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
      # If you assign specific users or groups, you will likely want to set this to true to enable
      # auto-provisioning
      create_account_on_first_login: false,
      redirect_uri: Rails.application.credentials.dig(:microsoft, :redirect_uri)
    },
    google: {
      enabled: true,
      create_account_on_first_login: false,
      create_admin_account_on_first_login: false,
      # client_id: Rails.application.credentials.dig(:google, :client_id),
      # client_secret: Rails.application.credentials.dig(:google, :client_secret),
      client_id: "552337866923-o1jd9ushva70su79c2ke8ftnu623chsl.apps.googleusercontent.com", # Will only work on localhost
      client_secret: "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", # Will only work on localhost
      redirect_uri: Rails.application.credentials.dig(:google, :redirect_uri)
    },
    github: {
      enabled: true,
      create_account_on_first_login: false,
      create_admin_account_on_first_login: false,
      # client_id: Rails.application.credentials.dig(:github, :client_id),
      # client_secret: Rails.application.credentials.dig(:github, :client_secret),
      client_id: "Ov23li9k0LpMXtq8FShb", # Will only work on localhost
      client_secret: "07233b63472b7f287ac11854e627670ddc096a22", # Will only work on localhost
      redirect_uri: Rails.application.credentials.dig(:github, :redirect_uri)
    }
  }
  # Blog
  config.posts = {
    enabled: true,
    prefix: "blog"
  }
end
