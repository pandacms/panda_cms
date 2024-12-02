Panda::CMS.configure do |config|
  config.admin_path = "/admin"
  config.authentication = {
    google_oauth2: {
      enabled: true,
      client_id: "test_client_id",
      client_secret: "test_client_secret"
    }
  }
end
