# Allow multiple threads for Puma
ENV["RAILS_MAX_THREADS"] = "4"
ENV["WEB_CONCURRENCY"] = "0"  # Keep workers at 0
ENV["RAILS_ENV"] = "test"

Capybara.default_max_wait_time = 5
Capybara.default_normalize_ws = true

# Set better_cuprite as both default and JavaScript driver
Capybara.default_driver = :better_cuprite
Capybara.javascript_driver = :better_cuprite

# Configure server
Capybara.server = :puma
Capybara.server_host = "127.0.0.1"
Capybara.server_port = 3001
Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"

# Configure Puma with multiple threads
Capybara.server = lambda do |app, port, host|
  require "rack/handler/puma"
  Rack::Handler::Puma.run(
    app,
    Host: host,
    Port: port,
    Silent: true,
    Threads: "1:4",  # Allow up to 4 threads
    workers: 0,
    persistent_timeout: 20,
    first_data_timeout: 20,
    environment: "test"
  )
end

puts "Capybara configured with:"
puts "  Host: #{Capybara.app_host}"
puts "  Driver: #{Capybara.default_driver}"
puts "  JavaScript Driver: #{Capybara.javascript_driver}"
puts "  Server: Puma (Multi-threaded)"
puts "  Max Threads: #{ENV["RAILS_MAX_THREADS"]}"
puts "  Workers: #{ENV["WEB_CONCURRENCY"]}"

RSpec.configure do |config|
  config.after(:each, type: :system) do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
