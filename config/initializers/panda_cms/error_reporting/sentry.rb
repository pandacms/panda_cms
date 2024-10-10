if PandaCms.config.error_reporting.sentry.enabled
  Sentry.init do |config|
    config.dsn = Rails.application.credentials.dig(:sentry, :dsn)
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]

    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for tracing.
    # We recommend adjusting this value in production.
    config.traces_sampler = lambda do |context|
      return 0.2 if Rails.env.production?
      1.0
    end
    # Set profiles_sample_rate to profile 100%
    # of sampled transactions.
    # We recommend adjusting this value in production.
    config.profiles_sample_rate = lambda do |context|
      return 0.2 if Rails.env.production?
      1.0
    end
  end
end
