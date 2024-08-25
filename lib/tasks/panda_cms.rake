require "tailwindcss-rails"
require "shellwords"

require "panda_cms/engine"

ENV["TAILWIND_PATH"] ||= Tailwindcss::Engine.root.join("exe/tailwindcss").to_s

namespace :panda_cms do
  desc "Generate missing blocks from template files"
  task generate_missing_blocks: [:environment] do
    PandaCms::Template.generate_missing_blocks
  end

  namespace :export do
    desc "Generate a .json export and output to stdout"
    task json: [:environment] do
      puts PandaCms::BulkEditor.export
    end
  end

  namespace :assets do
    desc "Compile assets for release"
    task :compile do
      # Copy all the JS files into public
      admin_js_path = PandaCms::Engine.root.join("app/javascript/panda_cms")
      FileUtils.cp_r "#{admin_js_path}/.", PandaCms::Engine.root.join("public/panda-cms-assets/javascripts")
    end

    desc "Build admin assets for Panda CMS"
    task :admin do
      # This is enough for development
      run_tailwind(
        root_path: PandaCms::Engine.root,
        input_path: "app/assets/stylesheets/panda_cms/application.tailwind.css",
        output_path: "app/assets/builds/panda_cms.css"
      )
    end

    desc "Build dummy assets for Panda CMS"
    # We only care about this in development
    task :dummy do
      run_tailwind(
        root_path: Rails.application.root,
        input_path: "app/assets/stylesheets/application.tailwind.css",
        output_path: "app/assets/builds/application.css",
        config_path: "config/tailwind.config.js"
      )
    end

    desc "Watch admin assets for Panda CMS"
    # We only care about this in development
    task :watch_admin do
      run_tailwind(
        root_path: PandaCms::Engine.root,
        input_path: "app/assets/stylesheets/panda_cms/application.tailwind.css",
        output_path: "app/assets/builds/panda_cms.css",
        watch: true
      )
    end

    desc "Watch dummy assets for Panda CMS"
    # We only care about this in development
    task :watch_dummy do
      run_tailwind(
        root_path: Rails.application.root,
        input_path: "app/assets/stylesheets/application.tailwind.css",
        output_path: "app/assets/builds/application.css",
        config_path: "config/tailwind.config.js",
        watch: true
      )
    end
  end
end

task default: [:spec, :panda_cms]

def run_tailwind(root_path:, input_path: nil, output_path: nil, config_path: nil, watch: false)
  Rails.logger = Logger.new($stdout)
  config_path ||= root_path.join("config/tailwind.config.js")

  command = [
    ENV["TAILWIND_PATH"],
    "-i #{root_path.join(input_path)}",
    "-o #{root_path.join(output_path)}",
    "-c #{root_path.join(config_path)}",
    "-m"
  ]

  command << "-w" if watch

  exec command.join(" ")
end
