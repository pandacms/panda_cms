pin "application_panda_cms", to: "panda_cms/application.js", preload: true

pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "tailwindcss-stimulus-components" # @6.0.2

# pin "@rails/activestorage", to: "@rails--activestorage.js" # @7.2.100
# pin "@rails/actioncable", to: "@rails--actioncable.js" # @7.2.100

pin_all_from PandaCms::Engine.root.join("app/javascript/panda_cms/controllers"), under: "controllers", to: "panda_cms/controllers"
