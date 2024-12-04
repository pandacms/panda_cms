module Panda
  module CMS
    class Railtie < Rails::Railtie
      config.before_initialize do |app|
        # Add lib to autoload paths
        paths = [
          Panda::CMS::Engine.root.join("lib"),
          Panda::CMS::Engine.root.join("lib", "panda"),
          Panda::CMS::Engine.root.join("lib", "panda", "cms"),
          Panda::CMS::Engine.root.join("lib", "panda", "cms", "editor_js"),
          Panda::CMS::Engine.root.join("lib", "panda", "cms", "editor_js", "blocks")
        ]

        paths.each do |path|
          app.config.autoload_paths << path
          app.config.eager_load_paths << path
        end
      end
    end
  end
end
