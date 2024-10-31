require_relative "lib/panda_cms/version"

Gem::Specification.new do |spec|
  spec.name = "panda_cms"
  spec.version = PandaCms::VERSION
  spec.author = ["Panda Software Limited"]
  spec.email = ["bamboo@pandacms.io"]
  spec.homepage = "https://pandacms.io"
  spec.summary = "Better websites on Rails."
  spec.license = "BSD-3-Clause"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/pandacms/panda_cms"
  spec.metadata["bug_tracker_uri"] = "https://github.com/pandacms/panda_cms/issues"
  spec.metadata["changelog_uri"] = "https://github.com/pandacms/panda_cms/releases"
  spec.metadata["github_repo"] = "ssh://github.com/panda_cms/panda_cms.git"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib,public}/**/*", "Rakefile", "README.md"]
  end

  spec.required_ruby_version = ">= 3.0"

  spec.add_dependency "activestorage-office-previewer" # , "~> 0.1"
  spec.add_dependency "awesome_nested_set", "~> 3.7"
  spec.add_dependency "aws-sdk-s3" # , "~> 1"
  spec.add_dependency "dry-configurable" # , "~> 1.2"
  spec.add_dependency "faraday", "~> 2"
  spec.add_dependency "faraday-retry", "~> 2"
  spec.add_dependency "faraday-multipart", "~> 1.0"
  spec.add_dependency "groupdate", "~> 6.4"
  spec.add_dependency "htmlentities", "~> 4.3"
  spec.add_dependency "image_processing", "~> 1.13"
  spec.add_dependency "importmap-rails" # , "~> 2.0"
  spec.add_dependency "local_time", "~> 3.0"
  spec.add_dependency "lookbook", "~> 2.0"
  spec.add_dependency "oaken"
  spec.add_dependency "omniauth", "~> 2.1"
  spec.add_dependency "omniauth-github", "~> 2.0" # TODO: Make this optional
  spec.add_dependency "omniauth-google-oauth2", "~> 1.1" # TODO: Make this optional
  spec.add_dependency "omniauth-microsoft_graph", "~> 2.0" # TODO: Make this optional
  spec.add_dependency "omniauth-rails_csrf_protection", "~> 1.0"
  spec.add_dependency "paper_trail", "~> 15.2"
  spec.add_dependency "pg" # , "~> 1.5"
  # spec.add_dependency "rails" # , ">= 7.1"
  spec.add_dependency "redcarpet" # , "~> 3.6"
  spec.add_dependency "silencer", "~> 2.0"
  spec.add_dependency "propshaft" # , "~> 1.0"
  spec.add_dependency "render_editorjs"
  spec.add_dependency "stimulus-rails" # , "~> 1.3"
  spec.add_dependency "tailwindcss-rails", "~> 3"
  spec.add_dependency "turbo-rails" # , "~> 2.0"
  spec.add_dependency "view_component", "~> 3"
  spec.add_dependency "whois-parser", "~> 2.0"

  spec.add_development_dependency "annotate"
  spec.add_development_dependency "better_errors" # , "~> 2.10"
  spec.add_development_dependency "binding_of_caller" # , "~> 1.0"
  spec.add_development_dependency "brakeman" # , "~> 6.2"
  # spec.add_development_dependency "bullet" # , "~> 7.2"
  spec.add_development_dependency "bundler-audit" # , "~> 0.9"
  spec.add_development_dependency "capybara" # , "~> 3.40"
  spec.add_development_dependency "cuprite"
  spec.add_development_dependency "danger" # , "~> 9.5"
  spec.add_development_dependency "danger-reek" # , "~> 0.3"
  spec.add_development_dependency "danger-rubocop" # , "~> 0.13"
  spec.add_development_dependency "danger-simplecov_json" # , "~> 0.3"
  spec.add_development_dependency "danger-todoist" # , "~> 2.0"
  spec.add_development_dependency "erb_lint" # , "~> 0.6"
  spec.add_development_dependency "factory_bot_rails"
  spec.add_development_dependency "faker" # , "~> 3.4"
  spec.add_development_dependency "fasterer" # , "~> 0.11"
  spec.add_development_dependency "htmlbeautifier" # , "~> 1.4"
  spec.add_development_dependency "lefthook" # , "~> 1.7"
  spec.add_development_dependency "listen" # , "~> 3.9"
  spec.add_development_dependency "msgpack" # , "~> 1.7"
  spec.add_development_dependency "puma" # , "~> 6.4"
  spec.add_development_dependency "rails-route-checker" # , "~> 0.6"
  spec.add_development_dependency "rspec-rails" # , "~> 7.0"
  spec.add_development_dependency "rspec-github" # , "~> 2.4"
  spec.add_development_dependency "shoulda-matchers" # , "~> 6.4"
  spec.add_development_dependency "simplecov" # , "~> 0.22"
  spec.add_development_dependency "simplecov-json" # , "~> 0.2"
  spec.add_development_dependency "simplecov_json_formatter" # , "~> 0.1"
  spec.add_development_dependency "simplecov-lcov" # , "~> 0.8"
  spec.add_development_dependency "simplecov_lcov_formatter" # , "~> 0.9"
  spec.add_development_dependency "standard" # , "~> 1.40"
  spec.add_development_dependency "ruby-lsp" # , "~> 0.18"
  spec.add_development_dependency "undercover" # , "~> 0.5"
  spec.add_development_dependency "yard-activerecord" # , "~> 0.0.16"

  spec.post_install_message = "🐼 💜"
end
