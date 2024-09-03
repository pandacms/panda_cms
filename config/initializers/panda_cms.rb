# The main title of your website
# The default is "Demo Site"
PandaCms.title = "Demo Site"
# The path to the administration panel, which must start with a /
# The default is "/admin"
PandaCms.admin_path = "/admin"
# Is login required to access the site?
PandaCms.require_login_to_view = false
# Authentication providers
PandaCms.authentication = {
  microsoft: {
    enabled: false,
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
    create_account_on_first_login: true,
    redirect_uri: Rails.application.credentials.dig(:microsoft, :redirect_uri)
  },
  google: {
    enabled: false,
    create_account_on_first_login: true,
    create_admin_account_on_first_login: false,
    redirect_uri: Rails.application.credentials.dig(:google, :redirect_uri)
  },
  github: {
    enabled: true,
    create_account_on_first_login: true,
    create_admin_account_on_first_login: true,
    # client_id: Rails.application.credentials.dig(:github, :client_id),
    # client_secret: Rails.application.credentials.dig(:github, :client_secret),
    client_id: "Ov23li9k0LpMXtq8FShb", # Will only work on localhost
    client_secret: "07233b63472b7f287ac11854e627670ddc096a22", # Will only work on localhost
    redirect_uri: Rails.application.credentials.dig(:github, :redirect_uri)
  }
}
# Blog
PandaCms.posts = {
  enabled: true,
  prefix: "blog"
}
