# The idea is this file needs nothing explicitly pinned from panda_cms,
# that should all get handled by the engine.rb, etc.

# This just checks that Stimulus can be included without conflicting
# pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
# pin "@hotwired/stimulus-loading", to: "@hotwired--stimulus-loading.js" # @1.0.0

# This just checks that a normal JS file and controllers folder can be included
pin_all_from "app/javascript/controllers", under: "controllers"
pin "application"
pin "tailwindcss-stimulus-components" # @6.0.2
pin "@rails/activestorage", to: "@rails--activestorage.js" # @7.2.100
