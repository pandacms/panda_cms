pin "application_panda_cms", to: "panda_cms/application_panda_cms.js", preload: true

pin "@hotwired/turbo", to: "@hotwired--turbo.js", preload: true # @8.0.12
pin "@rails/actioncable/src", to: "@rails--actioncable--src.js", preload: true # @7.2.101
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "panda_cms/stimulus-loading.js", preload: true
pin "tailwindcss-stimulus-components" # @6.1.2
pin "@editorjs/editorjs", to: "@editorjs--editorjs.js" # @2.30.6

# pin "@rails/activestorage", to: "@rails--activestorage.js" # @7.2.100
# pin "@rails/actioncable", to: "@rails--actioncable.js" # @7.2.100

pin_all_from PandaCms::Engine.root.join("app/javascript/panda_cms/controllers"), under: "panda_cms_controllers", to: "panda_cms/controllers"
pin_all_from PandaCms::Engine.root.join("app/javascript/panda_cms/editor"), under: "editor", to: "panda_cms/editor"
